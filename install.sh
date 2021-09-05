#!/bin/bash

rm ~/.bashrc
rm ~/.vimrc
rm ~/.tmux.conf
rm ~/.pythonstartup
rm ~/opt

mkdir ~/git/parsely

ln -s ~/git/dotfiles/bashrc ~/.bashrc
ln -s ~/git/dotfiles/vimrc ~/.vimrc
ln -s ~/git/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/git/dotfiles/opt ~/opt
ln -s ~/git/dotfiles/vim ~/.vim
ln -s ~/git/dotfiles/gitconfig ~/.gitconfig
ln -s ~/git/dotfiles/pythonstartup ~/.pythonstartup
ln -s ~/git/dotfiles/pull_repos.py ~/git/parsely/pull_repos.py
ln -s ~/git/dotfiles/ssh_config ~/.ssh/config
mkdir ~/.config/nvim
ln -s ~/git/dotfiles/nvim/init.vim ~/.config/nvim/init.vim

mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd
git clone https://github.com/nojhan/liquidprompt.git

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
sudo apt-get install tmux ipython vim-gtk-py2 git build-essential wmctrl gimp neovim rkhunter nodejs zlib1g-dev libssl-dev
pyenv install 3.6.7
pyenv global 3.6.7

# install a bunch of standard stuff
pip install flake8
pip install black

sudo npm install -g js-beautify

git clone git@github.com:Parsely/engineering.git ~/git/parsely/engineering
