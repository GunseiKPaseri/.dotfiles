#!/bin/sh

unlink ~/.vimrc 2>/dev/null
ln -sf ~/dotfiles/d/.vimrc ~/.vimrc

# confirm delete .vim

unlink ~/.vim 2>/dev/null
ln -sf ~/dotfiles/d/.vim ~/.vim

unlink ~/.minttyrc 2>/dev/null
ln -sf ~/dotfiles/d/.minttyrc ~/.minttyrc

#ln -sf ~/dotfiles/d/vscode/settings.json ~/.config/Code/User/settings.json

unlink ~/.bash_profile 2>/dev/null
ln -sf ~/dotfiles/d/.bash_profile ~/.bash_profile

mkdir -p ~/.config/fish
unlink ~/.config/fish/fromdotfiles 2>/dev/null
ln -sf ~/dotfiles/d/fish ~/.config/fish/fromdotfiles
