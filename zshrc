export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="rkj-repos"
CASE_SENSITIVE="true"
HYPHEN_INSENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

zstyle ':omz:update' mode auto      # update automatically without asking

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

plugins=(git tmux)

export AWS_PROFILE=parsely-prod
export CLOSURE_PATH="/home/emmett/.npm/closure-compiler/0.2.2/package/lib/vendor/compiler.jar"
export EDITOR=nvim
export GIT_SSL_NO_VERIFY=true
export GOOGLE_APPLICATION_CREDENTIALS=/opt/parsely-internal-f2b66dd71798.json
export JAVA_HOME="/usr/lib/jvm/default-java/"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/home/emmett/anaconda3/lib
export M2_HOME="/opt/apache-maven-3.3.3"
export NODE_PATH="/usr/local/lib/node_modules"
export PATH=$PATH:/sbin
export PATH=$PATH:/home/emmett/opt/bin:/opt/bin
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export ZSH_TMUX_AUTOSTART=true

eval `keychain --eval --agents ssh id_rsa`

if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi
if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

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
    MYSERVER=$(echo ${PARSELY_NODES[@]} |  tr '[:space:]' '\n' | fzf)
    history -s ssh "${MYSERVER}"
    ssh "${MYSERVER}"
}

xpsh() {
    SERVERS=($(echo ${PARSELY_NODES[@]} |  tr '[:space:]' '\n' | fzf --multi --reverse))
    xpanes --ssh $(echo "${SERVERS[*]}")
}


ssh-add ~/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem
source ~/.bashrc_secrets

source $ZSH/oh-my-zsh.sh

alias automatticproxy="ssh -N -D 8080 emmettbutler@proxy.automattic.com -i ~/.ssh/id_rsa_automattic"
alias googleauth="`cat ~/.google_auth_command`"
alias googleauthsudo="`cat ~/.google_auth_sudoer_command`"
alias parselyvpn="sudo openvpn --config ~/.openvpn/parsely-udp1194.ovpn"
alias pipu="pip install --upgrade --upgrade-strategy only-if-needed"
