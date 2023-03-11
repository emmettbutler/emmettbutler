{ config, lib, pkgs, ... }:

{
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
      ${pkgs.lib.readFile ../ansible/roles/userconfs/files/zshrc}
    '';
    promptInit = "";
  };
}
