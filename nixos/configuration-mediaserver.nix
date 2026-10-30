{
  config,
  lib,
  pkgs,
  ...
}: let
  makeService = {
    description,
    script ? null,
    serviceConfig ? {},
    ...
  } @ args:
    {
      inherit description;
      wantedBy = ["default.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
      startLimitBurst = 3;
      startLimitIntervalSec = 30;
      serviceConfig =
        {
          Type = "simple";
          Restart = "on-failure";
          RestartSec = 10;
          RemainAfterExit = "yes";
        }
        // serviceConfig;
    }
    // lib.optionalAttrs (script != null) {inherit script;}
    // (builtins.removeAttrs args ["description" "script" "serviceConfig"]);
  makeTunnelOci = name: {
    image = "cloudflare/cloudflared:2026.10.6";
    environmentFiles = ["/home/nixos/${name}-tunnel.env"];
    cmd = [
      "tunnel"
      "--no-autoupdate"
      "run"
    ];
    log-driver = "journald";
    extraOptions = ["--network=host"];
  };
  mkDir = path: {
    user ? "nixos",
    group ? "users",
    mode ? "757",
  }: {
    "${path}".d = {inherit user group mode;};
  };
  mkDirs = paths: settings:
    lib.mkMerge (map (path: mkDir path settings) paths);
  mkMergerfs = {
    device,
    depends ? ["/var/lib/plex/media" "/var/lib/plex/ssd-one"],
  }: {
    inherit device depends;
    fsType = "fuse.mergerfs";
    options = [
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
  };
  mkStandardMergerfs = name:
    mkMergerfs {
      device = "/var/lib/plex/media/${name}:/var/lib/plex/ssd-one/${name}";
    };
  mkProxy = backend: {
    locations."/".extraConfig = ''
      proxy_pass    ${backend};
    '';
  };
  mkProxyWithHeaders = backend: {
    locations."/".extraConfig = ''
      proxy_pass    ${backend};

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    '';
  };
in {
  imports = [
    ./hardware-configuration.nix
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-26.05/nixos-mailserver-nixos-26.05.tar.gz";
      sha256 = "0xp7ip4vafi6wx38ghwa191v4d84h2l9pczw2jzxysh5qdcv4akb";
    })
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = ["root" "emmett"];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  time.timeZone = "America/Los_Angeles";

  users.users = {
    nixos = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
    };
  };

  security = {
    acme = {
      acceptTerms = true;
      defaults.email = "admin@mail.pandaemonium.biz";

      certs."mail.pandaemonium.biz" = {
        domain = "mail.pandaemonium.biz";
        environmentFile = "/home/nixos/.acme-creds";
        postRun = "systemctl reload postfix dovecot";
      };
    };
    sudo.extraRules = [
      {
        users = ["nixos"];
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl reboot";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      settings = {
        connection = {
          "autoconnect-retries" = 0;
        };
      };
    };
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

  virtualisation.oci-containers.containers = {
    tunnel-ssh = makeTunnelOci "ssh";
    tunnel-jellyfin = makeTunnelOci "jellyfin";
    tunnel-overseerr = makeTunnelOci "overseerr";
    tunnel-wizarr = makeTunnelOci "wizarr";
    tunnel-sonarr = makeTunnelOci "sonarr";
    tunnel-radarr = makeTunnelOci "radarr";
    tunnel-tautulli = makeTunnelOci "tautulli";
    wizarr = {
      image = "ghcr.io/wizarrrr/wizarr:v2026.10.1";
      environment = {
        "DISABLE_BUILTIN_AUTH" = "false";
        "PGID" = "100";
        "PUID" = "1000";
        "TZ" = "US/Pacific";
      };
      volumes = ["/home/nixos/wizarr:/data:rw"];
      ports = ["5690:5690/tcp"];
      log-driver = "journald";
      extraOptions = ["--network=host"];
    };
    tdarr = {
      image = "ghcr.io/haveagitgat/tdarr:3.04.00";
      environment = {
        "PGID" = "100";
        "PUID" = "1000";
        "TZ" = "US/Pacific";
        "UMASK_SET" = "002";
        "auth" = "false";
        "cronPluginUpdate" = "";
        "ffmpegVersion" = "7";
        "inContainer" = "true";
        "internalNode" = "true";
        "maxLogSizeMB" = "10";
        "nodeName" = "BeelinkNode";
        "openBrowser" = "true";
        "serverIP" = "0.0.0.0";
        "serverPort" = "8266";
        "webUIPort" = "8265";
      };
      volumes = [
        "/var/lib/tdarr/configs:/app/configs:rw"
        "/var/lib/tdarr/logs:/app/logs:rw"
        "/var/lib/tdarr/server:/app/server:rw"
        "/var/lib/smb_root/temp:/temp:rw"
        "/var/lib/smb_root/movies:/movies:rw"
        "/var/lib/smb_root/tv:/tv:rw"
        "/var/lib/smb_root/kids_movies:/kids_movies:rw"
      ];
      ports = ["8265:8265/tcp" "8266:8266/tcp"];
      log-driver = "journald";
      extraOptions = ["--network=host"];
    };
    watchstate = {
      image = "ghcr.io/arabcoders/watchstate:v1.10.10";
      ports = ["8282:8080"];
      volumes = [
        "/var/lib/watchstate:/config:rw"
      ];
      environment = {
        TZ = "America/Los_Angeles";
      };
      user = "1000:1000";
    };
  };

  services = {
    postfix = {
      enable = true;
      settings.main = {
        relayhost = ["[smtp.mx.cloudflare.net]:465"];
        smtp_tls_wrappermode = lib.mkForce "yes";
        smtp_tls_security_level = lib.mkForce "encrypt";
        smtp_sasl_auth_enable = "yes";
        smtp_sasl_security_options = "noanonymous";
        smtp_sasl_password_maps = "texthash:/home/nixos/.smtp-creds";
        null_sender_rejection_transport = "local";
        bounce_notice_recipient = "admin@pandaemonium.biz";
        "2bounce_notice_recipient" = "admin@pandaemonium.biz";
        myorigin = "pandaemonium.biz";
      };
    };

    ddclient = {
      enable = true;
      interval = "5min";
      protocol = "cloudflare";
      zone = "pandaemonium.biz";
      domains = ["mail.pandaemonium.biz"];
      username = "token";
      passwordFile = "/home/nixos/.cloudflare_ddns_token";
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          workgroup = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          security = "user";
          "hosts allow" = "192.168.0. 127.0.0.1 10.0.0.";
          "guest account" = "nixos";
          "map to guest" = "Bad User";
          "passdb backend" = "tdbsam";
        };
        smb_root = {
          path = "/var/lib/smb_root";
          writeable = "yes";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "force user" = "nixos";
          "force group" = "users";
          "create mask" = "0777";
          "directory mask" = "0777";
          "force create mode" = "0777";
          "force directory mode" = "0777";
        };
      };
    };
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
    overseerr = {enable = true;};
    tautulli = {enable = true;};
    resolved = {enable = true;};
    openssh = {enable = true;};
    nginx = {
      enable = true;
      virtualHosts = {
        "${config.mailserver.fqdn}".enableACME = true;
        "stats.pandaemonium" = mkProxy "http://127.0.0.1:8181";
        "wizarr.pandaemonium" = mkProxy "http://127.0.0.1:5690";
        "tdarr.pandaemonium" = mkProxy "http://127.0.0.1:8265";
        "radarr.pandaemonium" = mkProxy "http://127.0.0.1:7878";
        "sonarr.pandaemonium" = mkProxy "http://127.0.0.1:8989";
        "overseerr.pandaemonium" = mkProxy "http://127.0.0.1:5055";
        "sabnzbd-private.pandaemonium" = mkProxyWithHeaders "http://192.168.10.2:8080";
        "sabnzbd.pandaemonium" = mkProxyWithHeaders "http://127.0.0.1:8080";
      };
    };
  };

  mailserver = {
    enable = true;
    stateVersion = 5;
    fqdn = "mail.pandaemonium.biz";
    domains = ["pandaemonium.biz"];

    x509.useACMEHost = config.mailserver.fqdn;
  };

  fileSystems = {
    "/var/lib/smb_root/movies" = mkStandardMergerfs "movies";
    "/var/lib/smb_root/tv" = mkStandardMergerfs "tv";

    "/var/lib/smb_root/kids_movies" = mkMergerfs {
      device = "/var/lib/plex/media/kids_movies:/var/lib/plex/ssd-one/kids";
    };
  };

  systemd = {
    tmpfiles = {
      rules = ["f /var/lib/systemd/linger/nixos"];

      settings = {
        "openvpn" = mkDir "/etc/openvpn" {mode = "757";};
        "custom-bins" = mkDir "/opt/bin" {mode = "757";};

        "media-drive-0" = mkDir "/var/lib/plex/media" {mode = "706";};
        "media-drive-1" = mkDir "/var/lib/plex/ssd-one" {mode = "706";};

        "sabnzbd-dl" = mkDirs [
          "/home/nixos/Downloads/complete"
          "/home/nixos/Downloads/incomplete"
          "/home/nixos/Downloads/private-complete"
          "/home/nixos/Downloads/private-incomplete"
        ] {mode = "755";};

        "watchstate" = mkDir "/var/lib/watchstate" {
          user = "root";
          group = "root";
          mode = "757";
        };

        "tdarr-directories" = lib.mkMerge [
          (mkDir "/var/lib/tdarr" {
            user = "root";
            group = "root";
            mode = "757";
          })

          (mkDirs [
              "/var/lib/smb_root"
              "/var/lib/smb_root/temp"
              "/var/lib/tdarr/server"
              "/var/lib/tdarr/logs"
              "/var/lib/tdarr/configs"
            ] {
              user = "501";
              group = "20";
              mode = "777";
            })
        ];
      };
    };
    services = lib.mapAttrs (name: value: makeService value) {
      vpn = {
        description = "Namespaced OpenVPN NordVPN";
        wants = ["network-online.target" "multi-user.target"];
        script = ''
          /run/current-system/sw/bin/ip netns delete protected || true
          /opt/bin/namespaced-openvpn --config /etc/openvpn/ovpn_udp/us12527.nordvpn.com.udp.ovpn
        '';
      };
      sabnzbd-private = {
        description = "SABnzbd downloader behind VPN";
        wants = ["network-online.target" "vpn.service"];
        script = ''
          /run/current-system/sw/bin/ip link add veth-host type veth peer name veth-ns || true
          /run/current-system/sw/bin/ip link set veth-ns netns protected || true
          /run/current-system/sw/bin/ip addr add 192.168.10.1/24 dev veth-host || true
          /run/current-system/sw/bin/ip link set veth-host up || true
          /run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip addr add 192.168.10.2/24 dev veth-ns || true
          /run/current-system/sw/bin/ip netns exec protected /run/current-system/sw/bin/ip link set veth-ns up || true
          /run/current-system/sw/bin/ip netns exec protected /run/wrappers/bin/sudo -u nixos -i /run/current-system/sw/bin/sabnzbd -f /home/nixos/.sabnzbd/sabnzbd-private.ini
        '';
      };
      sabnzbd = {
        description = "SABnzbd downloader";
        serviceConfig = {
          ExecStart = "/run/wrappers/bin/sudo -u nixos -i /run/current-system/sw/bin/sabnzbd";
        };
      };
    };
    user.services = lib.mapAttrs (name: value: makeService value) {
      sonarr = {
        description = "TV show NZB finder";
        script = ''
          /run/current-system/sw/bin/Sonarr
        '';
      };
      radarr = {
        description = "Movie NZB finder";
        script = ''
          /run/current-system/sw/bin/Radarr
        '';
      };
    };
  };
  environment.systemPackages = with pkgs; let
  in [
    ftop
    htop
    mergerfs
    nload
    neovim
    openvpn
    python3
    radarr
    sabnzbd
    sonarr
    tmux
    traceroute
    yt-dlp
  ];

  system.stateVersion = "26.05";
}
