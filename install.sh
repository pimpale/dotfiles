#!/bin/sh

#check dependencies
git --version
curl --version
nvim --version
i3 --version 
i3status --version
htop --version


ln -si ./zshrc ~/.zshrc 
ln -si ./ycm_extra_conf.py ~/.ycm_extra_conf.py
ln -si ./nvim ~/.config/nvim
ln -si ./htop ~/.config/htop
ln -si ./i3 ~/.config/i3
ln -si ./i3status ~/.config/i3status


