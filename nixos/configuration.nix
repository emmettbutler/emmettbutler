{ config, pkgs, inputs, lib, ... }:

with lib;

{
  imports = [ /etc/nixos/hardware-configuration.nix ];
  nix = {
    package = pkgs.nixVersions.git;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nix.settings.trusted-users = [ "root" "emmett" ];
  nix.gc.automatic = true;

  environment.pathsToLink = [ "/share/nix-direnv" ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    # beware: on framework laptop BIOS >=3.19, setting this to "deep" causes suspend to lock the machine
    # such that the only way to unlock it is by opening the chassis and powercycling it
    kernelParams = [ "mem_sleep_default=s2idle" "acpi=force" ];
  };

  networking = {
    networkmanager.enable = true;
    hostName = "hell";
    useDHCP = false;
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

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.gnome.excludePackages = with pkgs; [
    eog
    epiphany
    simple-scan
    totem
    yelp
    evince
    geary
    seahorse

    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    pkgs.gnome-photos
  ];

  environment.variables = let
    makePluginPath = format:
      (makeSearchPath format [
        "$HOME/.nix-profile/lib"
        "/run/current-system/sw/lib"
        "/etc/profiles/per-user/$USER/lib"
      ]) + ":$HOME/.${format}";
  in {
    DSSI_PATH = makePluginPath "dssi";
    LADSPA_PATH = makePluginPath "ladspa";
    LV2_PATH = makePluginPath "lv2";
    LXVST_PATH = makePluginPath "lxvst";
    VST_PATH = makePluginPath "vst";
    VST3_PATH = makePluginPath "vst3";
  };
  security.acme = {
    acceptTerms = true;
    defaults = { email = "emmett.butler321@gmail.com"; };
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
    user = "emmett";
  };
  services.overseerr = { enable = true; };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };
  hardware.pulseaudio.enable = false;
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  systemd.user.services = {
    raop = {
      description =
        "Load and run Pipewire's RAOP discovery module, allowing audio output via AirTunes";
      script = ''
        /run/current-system/sw/bin/pw-cli -m load-module libpipewire-module-raop-discover
      '';
      wantedBy = [ "default.target" ];
    };
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
        /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/emmett/.tunneltoken-overseerr`
      '';
    };
    tunnel-plex = {
      description = "Cloudflare tunnel exposing Plex";
      wantedBy = [ "default.target" ];
      script = ''
        /run/current-system/sw/bin/cloudflared tunnel login
        /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/emmett/.tunneltoken-plex`
      '';
    };
    tunnel-sonarr = {
      description = "Cloudflare tunnel exposing Sonarr";
      wantedBy = [ "default.target" ];
      script = ''
        /run/current-system/sw/bin/cloudflared tunnel login
        /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/emmett/.tunneltoken-sonarr`
      '';
    };
    tunnel-radarr = {
      description = "Cloudflare tunnel exposing Radarr";
      wantedBy = [ "default.target" ];
      script = ''
        /run/current-system/sw/bin/cloudflared tunnel login
        /run/current-system/sw/bin/cloudflared tunnel run --token `cat /home/emmett/.tunneltoken-radarr`
      '';
    };
  };

  users.groups.emmett.gid = 1000;
  users.users.emmett = {
    uid = 1000;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "libvirtd" "scanner" "lp" "realtime" "audio" ];
  };
  users.users.emmett.subUidRanges = [
    {
      count = 1;
      startUid = 1000;
    }
    {
      count = 65534;
      startUid = 100001;
    }
  ];
  users.users.emmett.subGidRanges = [
    {
      count = 1;
      startGid = 1000;
    }
    {
      count = 65534;
      startGid = 100001;
    }
  ];
  users.users.git = {
    createHome = true;
    isNormalUser = true;
    shell = pkgs.bash;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.seahorse.enable = lib.mkForce false;
  programs.zsh = {
    enable = true;
    shellAliases = { vim = "nvim"; };
    ohMyZsh = {
      enable = true;
      theme = "rkj-repos";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      ${pkgs.lib.readFile ../ansible/roles/linux_base/files/zshrc}
    '';
    promptInit = "";
  };

  nixpkgs.overlays = [
    (self: super: {
      slack = super.slack.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          sed -i -E "s/^Icon=.+$/Icon=\/home\/emmett\/.icons\/candy-icons-master\/apps\/scalable\/slack.svg/" $out/share/applications/slack.desktop
        '';
      });
    })
    (self: super: { wine = super.wineWowPackages.stable; })
  ];

  environment.systemPackages = with pkgs;
    let
      unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
      mypkgs = with pkgs; {
        pythonEnv = python311.withPackages (p: with p; [ psutil ]);
      };
    in ([
      ack
      ansible
      ast-grep
      cargo
      crane
      direnv
      dnsutils
      docker-compose
      doctl
      fzf
      gh
      git
      gnomeExtensions.vitals
      gnomeExtensions.user-themes
      gnumake
      gnupg
      hyperfine
      iptables
      jq
      lf
      nix-direnv
      openssl
      pinentry-gnome3
      gnome-terminal
      gnome-tweaks
      rsync
      rustc
      shellcheck
      shfmt
      stow
      tmux
      tmux-xpanes
      unzip
      wget
      xclip
      yq
      zip

      cloudflared
      radarr
      sabnzbd
      sonarr

      enpass
      gimp
      google-chrome
      handbrake
      vlc
      zoom-us

      airwindows-lv2
      ardour
      drumgizmo
      guitarix
      gxplugins-lv2
      inkscape
      lsp-plugins
      kmetronome
      pavucontrol
      qpwgraph
      unstable.shotcut
      surge
      surge-XT
      samplv1
      scribus
      tamgamp-lv2
      wine
      wine64
      yabridge
      yabridgectl

      neovimeb.neovimEB
      mypkgs.pythonEnv
    ]);

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  services.fprintd.enable = true;
  services.pcscd.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.gnome = {
    gnome-online-accounts.enable = lib.mkForce false;
    gnome-keyring.enable = lib.mkForce true;
  };

  virtualisation.docker.enable = true;

  security.sudo.extraConfig = ''
    Defaults    timestamp_timeout=500
    Defaults    timestamp_type=global
  '';
  security.rtkit.enable = true;
  security.pam = {
    services.gdm.enableGnomeKeyring = true;
    # this silences a warning thrown by yabridge
    loginLimits = [{
      domain = "*";
      type = "-";
      item = "memlock";
      value = "infinity";
    }];
  };

  system.stateVersion = "25.11";
}
