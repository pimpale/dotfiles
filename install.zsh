#!/bin/zsh

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

ln -s "$pwd/zshrc" "$HOME/.zshrc"
ln -s "$pwd/nvim" "$HOME/.config"
ln -s "$pwd/htop" "$HOME/.config"
ln -s "$pwd/i3" "$HOME/.config"
ln -s "$pwd/i3status" "$HOME/.config"
ln -s "$pwd/zathura" "$HOME/.config"
