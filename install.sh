#!/bin/sh

#check dependencies
git --version
curl --version
nvim --version
i3 --version 
i3status --version
htop --version

pwd=$(pwd)

ln -si "$pwd/zshrc" ~/.zshrc 
ln -si "$pwd/ycm_extra_conf.py" ~/.ycm_extra_conf.py
ln -si "$pwd/nvim" ~/.config
ln -si "$pwd/htop" ~/.config
ln -si "$pwd/i3" ~/.config
ln -si "$pwd/i3status" ~/.config


