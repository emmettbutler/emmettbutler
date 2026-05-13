{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "emmett" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Los_Angeles";

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  networking = {
    networkmanager.enable = true;
    hostName = "pandaemonium";
    firewall.enable = false;
    extraHosts = ''
      127.0.0.1 pandaemonium
      127.0.0.1 plex.pandaemonium
      127.0.0.1 sonarr.pandaemonium
      127.0.0.1 radarr.pandaemonium
      127.0.0.1 overseerr.pandaemonium
      127.0.0.1 sabnzbd.pandaemonium
    '';
  };

  services.openssh.enable = true;

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
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "nixos";
  };
  services.overseerr = { enable = true; };

  systemd.user.services = {
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
  environment.systemPackages = with pkgs;
    let
    in ([ cloudflared radarr sabnzbd sonarr ]);

  system.stateVersion = "25.11";
}
