{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
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
      ${pkgs.lib.readFile
      /home/emmett/git/emmettbutler/ansible/roles/userconfs/files/zshrc}
    '';
    promptInit = "";
  };
}
