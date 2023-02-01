#!/bin/sh

unlink ~/.vimrc 2>/dev/null
ln -sf ~/.dotfiles/d/.vimrc ~/.vimrc

# confirm delete .vim

unlink ~/.vim 2>/dev/null
ln -sf ~/.dotfiles/d/.vim ~/.vim

unlink ~/.minttyrc 2>/dev/null
ln -sf ~/.dotfiles/d/.minttyrc ~/.minttyrc

#ln -sf ~/dotfiles/d/vscode/settings.json ~/.config/Code/User/settings.json

unlink ~/.bash_profile 2>/dev/null
ln -sf ~/.dotfiles/d/.bash_profile ~/.bash_profile

mkdir -p ~/.config/fish/conf.d/
unlink ~/.config/starship.toml 2>/dev/null
ln -sf ~/.dotfiles/d/starship.toml ~/.config/starship.toml
