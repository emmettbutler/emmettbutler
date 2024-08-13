{ config, pkgs, inputs, lib, ... }:

with lib;

{
  imports = [ /etc/nixos/hardware-configuration.nix ];
  nix = {
    package = pkgs.nixUnstable;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  networking.networkmanager.enable = true;
  networking.hostName = "hell";
  networking.useDHCP = false;
  networking.firewall.enable = false;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
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
    gnome-weather
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

  sound.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  services.avahi.publish.addresses = true;
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
  systemd.user.services.raop = {
    description =
      "Load and run Pipewire's RAOP discovery module, allowing audio output via AirTunes";
    script = ''
      /run/current-system/sw/bin/pw-cli -m load-module libpipewire-module-raop-discover
    '';
    wantedBy = [ "default.target" ];
  };

  users.groups.emmett.gid = 1000;
  users.users.emmett = {
    uid = 1000;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "scanner" "lp" ];
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
      zoomUsFixed = pkgs.zoom-us.overrideAttrs (old: {
        postFixup = old.postFixup + ''
          wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
        '';
      });
      zoom = pkgs.zoom-us.overrideAttrs (old: {
        postFixup = old.postFixup + ''
          wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
        '';
      });
    })
    (self: super: {
      slack = super.slack.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          sed -i -E "s/^Icon=.+$/Icon=\/home\/emmett\/.icons\/candy-icons-master\/apps\/scalable\/slack.svg/" $out/share/applications/slack.desktop
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs;
    let
      mypkgs = with pkgs; {
        pythonEnv = python311.withPackages (p: with p; [ psutil ]);
        nixzshell = stdenvNoCC.mkDerivation {
          name = "nix-zshell";
          script = substituteAll {
            src = ./nix-zshell;
            inherit zsh bashInteractive;
          };
          phases = [ "buildPhase" ];
          buildPhase = ''
            mkdir -p $out/bin
            cat $script > $out/bin/nix-zshell
            chmod +x $out/bin/nix-zshell
          '';
        };
      };
    in ([
      ack
      ansible
      cargo
      direnv
      dnsutils
      docker-compose
      doctl
      fzf
      gh
      git
      gitAndTools.delta
      gnomeExtensions.system-monitor
      gnumake
      gnupg
      hyperfine
      iptables
      jq
      lf
      nix-direnv
      openssl
      pinentry
      pkgs.gnome.gnome-terminal
      pkgs.gnome3.gnome-tweaks
      rsync
      rustc
      shellcheck
      shfmt
      sops
      stow
      tmux
      tmux-xpanes
      unzip
      wget
      xclip
      yq
      zip

      discord
      enpass
      firefox
      gimp
      google-chrome
      handbrake
      slack
      vlc
      zoom

      ardour
      gxplugins-lv2
      pavucontrol
      qpwgraph
      surge
      surge-XT
      inkscape
      scribus
      wine

      neovimeb.neovimEB
      mypkgs.nixzshell
      mypkgs.pythonEnv
    ]);

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.xserver.enable = true;
  services.fprintd.enable = true;
  services.pcscd.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;

  security.pam.services.login.fprintAuth = false;
  security.pam.services.gdm-fingerprint =
    lib.mkIf (config.services.fprintd.enable) {
      text = ''
        auth       required                    pam_shells.so
        auth       requisite                   pam_nologin.so
        auth       requisite                   pam_faillock.so      preauth
        auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
        auth       optional                    pam_permit.so
        auth       required                    pam_env.so
        auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
        auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

        account    include                     login

        password   required                    pam_deny.so

        session    include                     login
        session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
      '';
    };

  virtualisation.docker.enable = true;

  security.sudo.extraConfig = ''
    Defaults    timestamp_timeout=500
    Defaults    timestamp_type=global
  '';
  security.rtkit.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  system.stateVersion = "23.11";
}
