#!/bin/zsh

pwd=$(~/dotfiles)

./uninstall.sh

mkdir ~/.config

ln -s "$pwd/zshrc" ~/.zshrc 
ln -s "$pwd/ycm_extra_conf.py" ~/.ycm_extra_conf.py
ln -s "$pwd/nvim" ~/.config
ln -s "$pwd/htop" ~/.config
ln -s "$pwd/i3" ~/.config
ln -s "$pwd/i3status" ~/.config
ln -s "$pwd/zathura" ~/.config
