#!/bin/zsh

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

ln -s "$pwd/ycm_extra_conf.py" "$HOME/.ycm_extra_conf.py"
ln -s "$pwd/zshrc" "$HOME/.zshrc"
ln -s "$pwd/nvim" "$HOME/.config"
ln -s "$pwd/htop" "$HOME/.config"
ln -s "$pwd/i3" "$HOME/.config"
ln -s "$pwd/i3status" "$HOME/.config"
ln -s "$pwd/zathura" "$HOME/.config"
