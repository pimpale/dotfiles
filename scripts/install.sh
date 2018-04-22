#!/bin/sh

pwd=$(pwd)


rm -ri ~/.zshrc
rm -ri ~/.ycm_extra_conf.py
rm -ri ~/.config/nvim
rm -ri ~/.config/htop
rm -ri ~/.config/i3
rm -ri ~/.config/i3status
rm -ri ~/.config/zathura

ln -s "$pwd/zshrc" ~/.zshrc 
ln -s "$pwd/ycm_extra_conf.py" ~/.ycm_extra_conf.py
ln -s "$pwd/nvim" ~/.config
ln -s "$pwd/htop" ~/.config
ln -s "$pwd/i3" ~/.config
ln -s "$pwd/i3status" ~/.config
ln -s "$pwd/zathura" ~/.config

