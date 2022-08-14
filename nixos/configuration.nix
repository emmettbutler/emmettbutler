# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

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
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

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

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

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
    openssh.authorizedKeys.keys = [ ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovimeb.neovimEB
    mypython310

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
    gnumake
    gnupg
    hyperfine
    jq
    lf
    nix-direnv
    pinentry-curses
    rsync
    shellcheck
    shfmt
    sops
    stow
    tmux
    tmux-xpanes
    keychain

    iptables
    google-chrome
    discord
    enpass
    spotify
    slack

    unzip
    yq
    zip
    openvpn
    openssl
    git
    wget
    terraform
    terraform-ls
  ];

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  programs.ssh = {
    extraConfig = ''
      Host *
          StrictHostKeyChecking no
          CheckHostIP no
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_rsa

      Host *.lan.cogtree.com
          User emmett.butler
          ForwardAgent yes

      Host *.cogtree.com
          User emmett.butler
          ForwardAgent yes

      Host *.compute-1.amazonaws.com
          ForwardAgent yes
          User hadoop
          IdentityFile /home/emmett/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem

      Host *-emr.cogtree.com
          ForwardAgent yes
          User hadoop
          IdentityFile /home/emmett/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem

      Host *.amazonaws.com
          ForwardAgent yes
          User hadoop
          IdentityFile /home/emmett/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem
    '';
  };

  systemd.services."parsely-vpn" = {
    enable = true;
    path = with pkgs; [ openvpn ];
    script = ''
      openvpn --config /home/emmett/parsely-udp1194.ovpn --auth-user-pass /home/emmett/vpn-credentials.txt
    '';
  };

  # Docker
  virtualisation.docker.enable = true;
  # Can't be enabled if running nomad
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
  system.stateVersion = "22.05"; # Did you read the comment?

}
