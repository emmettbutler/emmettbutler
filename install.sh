#!/bin/bash

cd ansible
sudo ansible-playbook -i inventory site.yml -c local
cd ..

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p ~/git/parsely

ln -fs ~/git/dotfiles/bashrc ~/.bashrc
ln -fs ~/git/dotfiles/liquidpromptrc ~/.liquidpromptrc

mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd

git clone https://github.com/nojhan/liquidprompt.git
git clone git@github.com:Parsely/engineering.git ~/git/parsely/engineering

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
