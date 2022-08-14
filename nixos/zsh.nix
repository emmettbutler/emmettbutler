{ config, lib, pkgs, ... }:

{
programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    ohMyZsh = {
      enable = true;
      theme = "rkj-repos";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      export ZSH_TMUX_AUTOSTART=true
      plugins=(git tmux)
      if [[ ! -e "/home/emmett/.zplug/init.zsh" ]]; then
          curl -sL --proto-redir -all,https \
              https://raw.githubusercontent.com/zplug/installer/master/installer.zsh \
              | zsh
      fi
      source "/home/emmett/.zplug/init.zsh"
      zplug "zsh-users/zsh-autosuggestions"
      zplug "zsh-users/zsh-completions"
      zplug "zsh-users/zsh-history-substring-search"
      zplug "agkozak/zsh-z"
      if ! zplug check --verbose; then
          printf "Install? [y/N]: "
          if read -q; then
              echo; zplug install
          fi
      fi
      zplug load
      eval `keychain --eval --agents ssh id_rsa`
      touch ~/.zshrc
    '';
    promptInit = "";
  };
}
