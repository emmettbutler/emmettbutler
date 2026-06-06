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
    virtualHosts."sabnzbd.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:8080;
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
    image = "ghcr.io/wizarrrr/wizarr";
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
        unitConfig = {
          Description = "Namespaced OpenVPN NordVPN";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
          StartLimitBurst = 3;
          StartLimitIntervalSec = 30;
        };

        serviceConfig = {
          Type = "simple";
          ExecStart =
            "/opt/bin/namespaced-openvpn --config /etc/openvpn/ovpn_udp/us12527.nordvpn.com.udp.ovpn";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        };
      };
      sabnzbd = {
        unitConfig = {
          Description = "SABnzbd downloader";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
          WantedBy = [ "default.target" ];
          StartLimitBurst = 3;
          StartLimitIntervalSec = 30;
        };

        serviceConfig = {
          Type = "simple";
          ExecStart =
            "/run/current-system/sw/bin/ip netns exec protected /run/wrappers/bin/sudo -u nixos -i /run/current-system/sw/bin/sabnzbd";
          Restart = "on-failure";
          RestartSec = 10;
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
      };
      radarr = {
        description = "Movie NZB finder";
        script = ''
          /run/current-system/sw/bin/Radarr
        '';
        wantedBy = [ "default.target" ];
      };
      tunnel-overseerr = {
        description = "Cloudflare tunnel exposing Overseerr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-overseerr`
        '';
      };
      tunnel-jellyfin = {
        description = "Cloudflare tunnel exposing Jellyfin";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-jellyfin`
        '';
      };
      tunnel-wizarr = {
        description = "Cloudflare tunnel exposing Wizarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-wizarr`
        '';
      };
      tunnel-sonarr = {
        description = "Cloudflare tunnel exposing Sonarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-sonarr`
        '';
      };
      tunnel-radarr = {
        description = "Cloudflare tunnel exposing Radarr";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-radarr`
        '';
      };
      tunnel-tautulli = {
        description = "Cloudflare tunnel exposing Tautulli";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-tautulli`
        '';
      };
      tunnel-ssh = {
        # client side needs the following in ssh config:
        # Host sh.pandaemonium.biz
        # ProxyCommand /run/current-system/sw/bin/cloudflared access ssh --hostname %h
        unitConfig = {
          Description = "Cloudflare tunnel exposing SSH";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
          WantedBy = [ "default.target" ];
          StartLimitBurst = 3;
          StartLimitIntervalSec = 30;
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = ''
            /run/current-system/sw/bin/cloudflared tunnel login
            /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-ssh`
          '';
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
