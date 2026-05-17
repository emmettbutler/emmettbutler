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
      127.0.0.1 plex.pandaemonium
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
  systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/nixos" ];

  services.nginx = {
    enable = true;
    virtualHosts."plex.pandaemonium" = {
      locations."/".extraConfig = ''
        proxy_pass    http://127.0.0.1:32400;
      '';
      extraConfig = ''
        proxy_set_header Host "127.0.0.1:32400";
        proxy_set_header Referer "";
        proxy_set_header Origin "http://127.0.0.1:32400";
            proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
        proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
        proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_redirect off;
        proxy_buffering off;
      '';
    };
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
    overseerr = { enable = true; };
    tautulli = { enable = true; };
  };

  systemd = {
    tmpfiles.settings = {
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
      sabnzbd = {
        description = "NZB downloader";
        script = ''
          /run/current-system/sw/bin/sabnzbd
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
      tunnel-plex = {
        description = "Cloudflare tunnel exposing Plex";
        wantedBy = [ "default.target" ];
        script = ''
          /run/current-system/sw/bin/cloudflared tunnel login
          /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/nixos/.tunneltoken-plex`
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
    };
  };
  environment.systemPackages = with pkgs;
    let
    in ([ cloudflared radarr sabnzbd sonarr ]);

  system.stateVersion = "25.11";
}
