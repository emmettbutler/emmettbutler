#!/bin/bash

rm -f ~/.bashrc
rm -f ~/.vimrc
rm -f ~/.tmux.conf
rm -f ~/.pythonstartup
rm -f ~/opt

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p ~/git/parsely

ln -fs ~/git/dotfiles/bashrc ~/.bashrc
ln -fs ~/git/dotfiles/zshrc ~/.zshrc
ln -fs ~/git/dotfiles/vimrc ~/.vimrc
ln -fs ~/git/dotfiles/liquidpromptrc ~/.liquidpromptrc
ln -fs ~/git/dotfiles/tmux.conf ~/.tmux.conf
ln -fs ~/git/dotfiles/opt ~/opt
ln -fs ~/git/dotfiles/vim ~/.vim
ln -fs ~/git/dotfiles/gitconfig ~/.gitconfig
ln -fs ~/git/dotfiles/pythonstartup ~/.pythonstartup
ln -fs ~/git/dotfiles/pull_repos.py ~/git/parsely/pull_repos.py
ln -fs ~/git/dotfiles/ssh_config ~/.ssh/config
mkdir -p ~/.config/nvim
ln -fs ~/git/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd

echo "deb https://apt.enpass.io/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
wget -O - https://apt.enpass.io/keys/enpass-linux.key | sudo tee /etc/apt/trusted.gpg.d/enpass.asc

curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo add-apt-repository ppa:neovim-ppa/stable
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update
sudo apt-get install enpass

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
git clone https://github.com/nojhan/liquidprompt.git
git clone git@github.com:Parsely/engineering.git ~/git/parsely/engineering

sudo apt-get install pipx python3.8-venv tmux git vlc keychain build-essential wmctrl gimp neovim rkhunter nodejs zlib1g-dev libffi-dev libssl-dev ffmpeg v4l2loopback-dkms npm obs-studio fzf spotify-client awscli

rm ~/google-chrome-stable*
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

pyenv install 3.9.7
pyenv global 3.9.7

pyenv virtualenv 3.9.7 python-nvim

# install a bunch of standard stuff
pip install flake8
pip install --user black==21.5b0  # pinned to specific version to maintain vim plugin compatibility
pip install aws-google-auth

sudo npm install -g js-beautify

# turn off keyboard autorepeat, for vim practice
gsettings set org.gnome.desktop.peripherals.keyboard repeat false
