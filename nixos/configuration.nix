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
      10.0.0.42 pandaemonium
      10.0.0.42 plex.pandaemonium
      10.0.0.42 sonarr.pandaemonium
      10.0.0.42 radarr.pandaemonium
      10.0.0.42 overseerr.pandaemonium
      10.0.0.42 sabnzbd.pandaemonium
      10.0.0.42 sabnzbd-private.pandaemonium
      10.0.0.42 stats.pandaemonium
      10.0.0.42 wizarr.pandaemonium
      10.0.0.42 tdarr.pandaemonium
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
  services.openssh.enable = true;

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
  hardware.sane = { enable = true; };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };
  systemd = {
    services.wgnord = let
      country = "United States";
      tokenFile = "/home/emmett/.nordkey";
      # This template works as is but you can customise it if you want
      template = pkgs.writeText "template.conf" ''
        [Interface]
        PrivateKey = PRIVKEY
        Address = 10.5.0.2/32
        MTU = 1350
        DNS = 103.86.96.100 103.86.99.100

        [Peer]
        PublicKey = SERVER_PUBKEY
        AllowedIPs = 0.0.0.0/0, ::/0
        Endpoint = SERVER_IP:51820
        PersistentKeepalive = 25
      '';
    in {
      unitConfig = {
        Description = "Nord Wireguard VPN";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
        StartLimitBurst = 3;
        StartLimitIntervalSec = 30;
      };

      serviceConfig = {
        Type = "oneshot";
        StateDirectory = "wgnord";
        StateDirectoryMode = "0700";
        ConfigurationDirectory = "wireguard";
        ConfigurationDirectoryMode = "0700";
        ExecStartPre = [
          "${
            lib.getExe' pkgs.coreutils "ln"
          } -fs ${template} /var/lib/wgnord/template.conf"
          "${lib.getExe' pkgs.bash "sh"} -c '${
            lib.getExe pkgs.wgnord
          } login \"$(<${tokenFile})\"'"
        ];
        ExecStart = ''${lib.getExe pkgs.wgnord} connect "${country}"'';
        ExecStop = "-${lib.getExe pkgs.wgnord} disconnect";
        Restart = "on-failure";
        RestartSec = 10;
        RemainAfterExit = "yes";
      };
    };
    user.services = {
      raop = {
        description =
          "Load and run Pipewire's RAOP discovery module, allowing audio output via AirTunes";
        script = ''
          /run/current-system/sw/bin/pw-cli -m load-module libpipewire-module-raop-discover
        '';
        wantedBy = [ "default.target" ];
      };
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
      cloudflared
      crane
      direnv
      dnsutils
      docker-compose
      doctl
      fzf
      gh
      ghostty
      git
      gnomeExtensions.vitals
      gnomeExtensions.user-themes
      gnumake
      gnupg
      hyperfine
      iptables
      jellyfin-desktop
      jq
      lf
      nix-direnv
      openresolv
      openssl
      pinentry-gnome3
      plex-desktop
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
      wgnord
      wireguard-tools
      xclip
      yq
      zip

      enpass
      gimp
      google-chrome
      handbrake
      obs-studio
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

  services.printing = { enable = true; };
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
    loginLimits = [
      {
        domain = "*";
        type = "-";
        item = "memlock";
        value = "infinity";
      }
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@audio";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };

  system.stateVersion = "25.11";
}
