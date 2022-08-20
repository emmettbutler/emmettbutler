{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      automatticproxy =
        "ssh -N -D 8080 emmettbutler@proxy.automattic.com -i /home/emmett/.ssh/id_rsa_automattic";
      pipu = "pip install --upgrade --upgrade-strategy only-if-needed";
      pipzone =
        "nix-shell ~/git/emmettbutler/nixos/pip-shell.nix -I nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs";
      update =
        "sudo nix flake update /home/emmett/git/emmettbutler/nixos/nvimeb --experimental-features 'nix-command flakes' && sudo nix flake update /home/emmett/git/emmettbutler/nixos --experimental-features 'nix-command flakes' && sudo nixos-rebuild switch --flake /home/emmett/git/emmettbutler/nixos --impure --verbose";
      updatenoflakes =
        "sudo nixos-rebuild switch --flake /home/emmett/git/emmettbutler/nixos --impure --verbose";
    };
    ohMyZsh = {
      enable = true;
      theme = "rkj-repos";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      ${pkgs.lib.readFile ../ansible/roles/development/files/zshrc}
    '';
    promptInit = "";
  };
}
