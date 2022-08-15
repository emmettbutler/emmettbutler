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
        "sudo nixos-rebuild switch --flake /home/emmett/git/emmettbutler/nixos --impure";
    };
    ohMyZsh = {
      enable = true;
      theme = "rkj-repos";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      export ZSH_TMUX_AUTOSTART=true
      zstyle ':omz:update' mode auto
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
      export AWS_PROFILE=parsely-prod
      export CLOSURE_PATH="/home/emmett/.npm/closure-compiler/0.2.2/package/lib/vendor/compiler.jar"
      export EDITOR=nvim
      export GIT_SSL_NO_VERIFY=true
      export ZSH_TMUX_AUTOSTART=true

      eval `keychain --eval --agents ssh id_rsa`

      if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi
      if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi

      source ~/.parsely-bashrc

      updateparselynodes() {
          local _aws_profile="parsely-prod"
          local _inventory_file="$HOME/.parsely-bashrc"

          rm -f "$_inventory_file"
          echo 'PARSELY_NODES=(' > "$_inventory_file"

          for region in us-east-1 us-west-2 eu-west-1; do
              aws --profile "$_aws_profile" ec2 describe-instances \
                  --region "$region" \
                  --filters "Name=tag:ansible_managed,Values=true" \
                  --query "Reservations[*].Instances[].Tags[?Key == 'ansible_hostname'].Value[] | [] | sort(@)" \
                  --output text | tr "\t" "\n"
          done >> "$_inventory_file"
          echo ')' >> "$_inventory_file"
      }

      psh() {
          MYSERVER=$(echo $PARSELY_NODES[@] |  tr '[:space:]' '\n' | fzf)
          history -s ssh "$MYSERVER"
          ssh "$MYSERVER"
      }

      xpsh() {
          SERVERS=($(echo $PARSELY_NODES[@] |  tr '[:space:]' '\n' | fzf --multi --reverse))
          xpanes --ssh $(echo "$SERVERS[*]")
      }

      ssh-add ~/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem
      ssh-add ~/.ssh/id_rsa
      ssh-add ~/.ssh/id_rsa_automattic
      source ~/.bashrc_secrets

      touch ~/.zshrc
    '';

    promptInit = "";
  };
}
