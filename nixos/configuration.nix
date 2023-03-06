# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ./zsh.nix ];
  # Enable flakes
  # Keep outputs and derivations for nix-direnv
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nix.trustedUsers = [ "root" "emmett" ];

  environment.pathsToLink = [ "/share/nix-direnv" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  networking.networkmanager.enable = true;
  networking.hostName = "hell"; # Define your hostname.

  # Typical system config
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.fprintd.enable = true;

  services.dbus.packages = [ pkgs.gcr ];

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    eog # image viewer
    epiphany # web browser
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
    geary # email client
    seahorse # password manager

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

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  networking.useDHCP = false;

  # Users/Groups
  # Don't forget to set a password with ‘passwd’.
  users.groups.emmett.gid = 1000;
  users.users.emmett = {
    uid = 1000;
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
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

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.gnome.gnome-online-accounts.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  programs.seahorse.enable = lib.mkForce false;

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
        pythonEnv = python310.withPackages (p: with p; [ psutil ]);
        nixzshell = stdenvNoCC.mkDerivation {
          name = "nix-zshell";

          script = substituteAll {
            src = /home/emmett/git/emmettbutler/nixos/nix-zshell;
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
      neovimeb.neovimEB
      mypkgs.nixzshell
      ack
      amazon-ecr-credential-helper
      ansible
      awscli2
      direnv
      dnsutils
      docker-compose
      devpi-client
      doctl
      fzf
      gh
      glab
      gitAndTools.delta
      gnomeExtensions.system-monitor
      pkgs.gnome3.gnome-tweaks
      gnumake
      gnupg
      hyperfine
      jq
      lf
      nix-direnv
      pinentry
      mypkgs.pythonEnv
      rsync
      shellcheck
      shfmt
      slack
      sops
      stow
      pkgs.gnome.gnome-terminal
      tmux
      tmux-xpanes

      iptables
      google-chrome
      discord
      enpass
      spotify
      vlc
      zoom

      unzip
      yq
      zip
      openvpn
      openssl
      git
      wget
    ]);

  # List services that you want to enable:
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Can't be enabled if running nomad
  virtualisation.docker.enable = true;
  virtualisation.docker.extraOptions = "--userns-remap='emmett'";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Allow sudo to last for a little bit
  security.sudo.extraConfig = ''
    Defaults    timestamp_timeout=30
    Defaults    timestamp_type=global
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
