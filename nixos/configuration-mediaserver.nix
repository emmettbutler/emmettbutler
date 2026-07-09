{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "emmett" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Los_Angeles";

  users.users = {
    nixos = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
    };
  };

  security.sudo.extraRules = [{
    users = [ "nixos" ];
    commands = [{
      command = "/run/current-system/sw/bin/systemctl reboot";
      options = [ "NOPASSWD" ];
    }];
  }];

  networking = {
    networkmanager.enable = true;
    hostName = "pandaemonium";
    useDHCP = false;
    firewall.enable = false;
    extraHosts = ''
      127.0.0.1 pandaemonium
      127.0.0.1 sonarr.pandaemonium
      127.0.0.1 radarr.pandaemonium
      127.0.0.1 overseerr.pandaemonium
      127.0.0.1 sabnzbd.pandaemonium
      127.0.0.1 sabnzbd-private.pandaemonium
      127.0.0.1 stats.pandaemonium
      127.0.0.1 wizarr.pandaemonium
      127.0.0.1 tdarr.pandaemonium
    '';
  };

  services.openssh = { enable = true; };
  services.nginx = {
    enable = true;
    virtualHosts."stats.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:8181;
      '';
    };
    virtualHosts."wizarr.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:5690;
      '';
    };
    virtualHosts."tdarr.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:8265;
      '';
    };
    virtualHosts."sabnzbd-private.pandaemonium" = {
      #/run/current-system/sw/bin/ip link add veth-host type veth peer name veth-ns || true
      #/run/current-system/sw/bin/ip link set veth-ns netns protected || true
      #/run/current-system/sw/bin/ip addr add 192.168.10.1/24 dev veth-host || true
      #/run/current-system/sw/bin/ip link set veth-host up || true
      #/run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip addr add 192.168.10.2/24 dev veth-ns || true
      #/run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip link set veth-ns up || true
      locations."/".extraConfig = ''
        proxy_pass    http://192.168.10.2:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
    virtualHosts."sabnzbd.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
    virtualHosts."radarr.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:7878;
      '';
    };
    virtualHosts."sonarr.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:8989;
      '';
    };
    virtualHosts."overseerr.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:5055;
      '';
    };
  };
  virtualisation.oci-containers.containers."wizarr" = {
    image = "ghcr.io/wizarrrr/wizarr:v2026.7.1";
    environment = {
      "DISABLE_BUILTIN_AUTH" = "false";
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "US/Pacific";
    };
    volumes = [ "/home/nixos/wizarr:/data:rw" ];
    ports = [ "5690:5690/tcp" ];
    log-driver = "journald";
    extraOptions = [ "--network=host" ];
  };
  virtualisation.oci-containers.containers."tdarr" = {
    image = "ghcr.io/haveagitgat/tdarr:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "US/Pacific";
      "UMASK_SET" = "002";
      "auth" = "false";
      "cronPluginUpdate" = "";
      "ffmpegVersion" = "7";
      "inContainer" = "true";
      "internalNode" = "true";
      "maxLogSizeMB" = "10";
      "nodeName" = "MyInternalNode";
      "openBrowser" = "true";
      "serverIP" = "0.0.0.0";
      "serverPort" = "8266";
      "webUIPort" = "8265";
    };
    volumes = [
      "/var/lib/tdarr/configs:/app/configs:rw"
      "/var/lib/tdarr/logs:/app/logs:rw"
      "/var/lib/tdarr/server:/app/server:rw"
      "/transcode_cache:/temp:rw"
      "/var/lib/plex/media:/media:rw"
    ];
    ports = [ "8265:8265/tcp" "8266:8266/tcp" ];
    log-driver = "journald";
    extraOptions = [ "--network=host" ];
  };

  services = {
    plex = {
      enable = true;
      openFirewall = true;
      user = "nixos";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "nixos";
    };
    overseerr = { enable = true; };
    tautulli = { enable = true; };
    resolved = { enable = true; };
  };

  systemd = {
    tmpfiles = {
      rules = [ "f /var/lib/systemd/linger/nixos" ];
      settings = {
        "openvpn" = {
          "/etc/openvpn" = {
            d = {
              user = "nixos";
              group = "users";
              mode = "757";
            };
          };
        };
        "custom-bins" = {
          "/opt/bin" = {
            d = {
              user = "nixos";
              group = "users";
              mode = "757";
            };
          };
        };
        "media-mount-point" = {
          "/var/lib/plex/media" = {
            d = {
              user = "nixos";
              group = "users";
              mode = "706";
            };
          };
        };
        "tdarr-directories" = {
          "/var/lib/tdarr" = {
            d = {
              user = "root";
              group = "root";
              mode = "757";
            };
          };
          "/transcode_cache" = {
            d = {
              user = "nixos";
              group = "1000";
              mode = "755";
            };
          };
          "/var/lib/tdarr/server" = {
            d = {
              user = "nixos";
              group = "1000";
              mode = "757";
            };
          };
          "/var/lib/tdarr/logs" = {
            d = {
              user = "nixos";
              group = "1000";
              mode = "757";
            };
          };
          "/var/lib/tdarr/configs" = {
            d = {
              user = "nixos";
              group = "1000";
              mode = "757";
            };
          };
        };
      };
    };
    services = {
      vpn = {
        description = "Namespaced OpenVPN NordVPN";
        wants = [ "multi-user.target" ];
        wantedBy = [ "default.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        script = ''
          /run/current-system/sw/bin/ip netns delete protected || true
          /opt/bin/namespaced-openvpn --config /etc/openvpn/ovpn_udp/us12527.nordvpn.com.udp.ovpn
        '';

        serviceConfig = { Type = "simple"; };
      };
      sabnzbd-private = {
        description = "SABnzbd downloader behind VPN";
        wants = [ "vpn.service" ];
        wantedBy = [ "default.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 3;
        script = ''
          /run/current-system/sw/bin/ip link add veth-host type veth peer name veth-ns || true
          /run/current-system/sw/bin/ip link set veth-ns netns protected || true
          /run/current-system/sw/bin/ip addr add 192.168.10.1/24 dev veth-host || true
          /run/current-system/sw/bin/ip link set veth-host up || true
          /run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip addr add 192.168.10.2/24 dev veth-ns || true
          /run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip link set veth-ns up || true
          /run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/sabnzbd -f /home/nixos/.sabnzbd/sabnzbd-private.ini
        '';

        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 1;
          RemainAfterExit = "yes";
        };
      };
      sabnzbd = {
        description = "SABnzbd downloader";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "default.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 3;

        serviceConfig = {
          Type = "simple";
          ExecStart =
            "/run/wrappers/bin/sudo -u nixos -i /run/current-system/sw/bin/sabnzbd";
          Restart = "on-failure";
          RestartSec = 1;
          RemainAfterExit = "yes";
        };
      };
    };
    user.services = {
      sonarr = {
        description = "TV show NZB finder";
        script = ''
          /run/current-system/sw/bin/Sonarr
        '';
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      radarr = {
        description = "Movie NZB finder";
        script = ''
          /run/current-system/sw/bin/Radarr
        '';
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-overseerr = {
        description = "Cloudflare tunnel exposing Overseerr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-overseerr`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-jellyfin = {
        description = "Cloudflare tunnel exposing Jellyfin";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-jellyfin`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-wizarr = {
        description = "Cloudflare tunnel exposing Wizarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-wizarr`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-sonarr = {
        description = "Cloudflare tunnel exposing Sonarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-sonarr`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-radarr = {
        description = "Cloudflare tunnel exposing Radarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-radarr`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-tautulli = {
        description = "Cloudflare tunnel exposing Tautulli";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-tautulli`
        '';
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      tunnel-ssh = {
        # client side needs the following in ssh config:
        # Host sh.pandaemonium.biz
        # ProxyCommand /run/current-system/sw/bin/cloudflared access ssh --hostname %h
        description = "Cloudflare tunnel exposing SSH";
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-ssh`
        '';
        wantedBy = [ "default.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        startLimitBurst = 3;
        startLimitIntervalSec = 30;
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
    };
  };
  environment.systemPackages = with pkgs;
    let
    in ([
      cloudflared
      ftop
      htop
      nload
      neovim
      openvpn
      python3
      radarr
      sabnzbd
      sonarr
      traceroute
      yt-dlp
    ]);

  system.stateVersion = "25.11";
}
