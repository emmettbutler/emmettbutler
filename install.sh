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

# install a bunch of standard stuff
sudo apt-get install tmux ipython vim-gtk-py2 git build-essential wmctrl python-pip python3-pip gimp neovim python3-venv rkhunter nodejs
sudo pip3 install flake8
sudo pip3 install black
sudo pip3 install pynvim
sudo pip3 install neovim
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update
sudo apt-get install python-apt python3.6
cd /usr/lib/python3/dist-packages
sudo ln -s apt_pkg.cpython-{35m,36m}-x86_64-linux-gnu.so

sudo npm install -g js-beautify

git clone git@github.com:edenhill/librdkafka.git
cd librdkafka
./configure && make && sudo make install && sudo ldconfig


git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

git clone git@github.com:Parsely/engineering.git ~/git/parsely/engineering

