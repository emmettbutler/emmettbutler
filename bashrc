# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='mac'
fi

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

##################################################
#USER-ADDED FUNCTIONS/ALIASES
##################################################
export EDITOR=vim

alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias ls='ls -al'
alias grep='grep -n --color'
alias hist="history | grep"
alias clj="java -cp /usr/local/bin/clojure-1.6.0/clojure-1.6.0.jar clojure.main"

alias xrestart="sudo /etc/init.d/gdm restart"
alias fanstat='sudo cat /proc/acpi/ibm/fan'

if [[ $platform == 'linux' ]]; then
    export WORKON_HOME="/home/emmett/virtualenvs"
elif [[ $platform == 'mac' ]]; then
    export WORKON_HOME="/Users/emmettbutler/virtualenvs"
fi
export GRAILS_HOME="/opt/grails"
export PYTHONSTARTUP="~/.pythonstartup"

# path modifications
export PATH=$PATH:/usr/lib/postgresql/8.4/bin:/opt/grails/bin:/opt/mongo/bin:/opt/flex/bin
export PATH=$PATH:/home/emmett/tools/storm-0.8.2/bin
export PATH=$PATH:/sbin
export PATH=$PATH:/opt/apache-maven-3.3.3/bin
export PATH=$PATH:/home/emmett/opt/bin:/opt/bin
export PATH=$PATH:~/opt/bin
export PATH=$PATH:/usr/share/elasticsearch/bin
export PATH=$PATH:/opt/llvm/build/Release+Asserts/bin
export PATH=$PATH:/opt/python-3.4.3/bin
export PATH=$PATH:/opt/python-3.5.0/bin
export PATH=$PATH:/opt/python-3.6.0/bin
export PATH=$PATH:/home/emmett/Android/Sdk
alias pyspark_ipython='PYSPARK_DRIVER_PYTHON=/usr/local/bin/ipython PYSPARK_PYTHON=/home/emmett/virtualenvs/ct-casterisk-rebuilds/bin/python pyspark --master local[8]'
alias pyspark24_ipython='PYSPARK_DRIVER_PYTHON=/usr/local/bin/ipython PYSPARK_PYTHON=/home/emmett/virtualenvs/ct-casterisk-rebuilds/bin/python pyspark --master local[8]'

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/home/emmett/anaconda3/lib

export JAVA_HOME="/usr/lib/jvm/default-java/"
export M2_HOME="/opt/apache-maven-3.3.3"
export BROWSERSTACK_USERNAME="emmettbutler1"
export BROWSERSTACK_KEY="6QjFGomTEXyqL6TMpFD5"
export TZ="UTC"  # for pyspark
export NODE_PATH="/usr/local/lib/node_modules"

#print and execute the command at the specified line+1 of the bash history file
#+1 because the numbers that `history` displays are apparently off by one
function histr () {
    cmd=`awk NR==$(($1+1)) /home/emmett/.bash_history`
    echo $cmd
    $cmd
}

alias pconnect='ssh -L 27017:localhost:27017 cogtree@174.143.145.120'
alias hay='find . -name'
alias nes='mednafen'
alias tmux='TERM=xterm-256color tmux'
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"
alias pipu="pip install --upgrade --upgrade-strategy only-if-needed"
alias androidstudio="/opt/android-studio/android-studio/bin/studio.sh"
# unset/set AWS_PROFILE before/after auth OR alias AWS_PROFILE export so it's easy to use repeatedly
alias googleauth="`cat ~/.google_auth_command`"
alias googleauthsudo="`cat ~/.google_auth_sudoer_command`"
alias parselyvpn="sudo openvpn --config ~/.openvpn/parsely-udp1194.ovpn"
alias automatticproxy="ssh -N -D 8080 emmettbutler@proxy.automattic.com -i ~/.ssh/id_rsa_automattic"


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

source /usr/local/bin/virtualenvwrapper.sh
source ~/liquidprompt/liquidprompt

# don't check cacert
export GIT_SSL_NO_VERIFY=true

alias minify="./build_scripts/assets/compile_manifest.py --csso-path $CSSO_PATH --closure-path $CLOSURE_PATH"
export CSSO_PATH="/usr/local/bin/csso"
export CLOSURE_PATH="/home/emmett/.npm/closure-compiler/0.2.2/package/lib/vendor/compiler.jar"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# added by travis gem
[ -f /home/emmett/.travis/travis.sh ] && source /home/emmett/.travis/travis.sh

eval `keychain --eval --agents ssh id_rsa`

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/google-cloud-sdk/path.bash.inc' ]; then source '/opt/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/opt/google-cloud-sdk/completion.bash.inc' ]; then source '/opt/google-cloud-sdk/completion.bash.inc'; fi
export GOOGLE_APPLICATION_CREDENTIALS=/opt/parsely-internal-f2b66dd71798.json

if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi


ssh-add ~/git/parsely/engineering/casterisk-realtime/emr/emr_jobs.pem
~/.bashrc_secrets
