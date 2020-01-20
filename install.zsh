#!/bin/zsh

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

ln -sf $opts "$pwd/zshrc" "$HOME/.zshrc"
ln -sf $opts "$pwd/nvim" "$HOME/.config"
ln -sf $opts "$pwd/kak" "$HOME/.config"
ln -sf $opts "$pwd/i3" "$HOME/.config"
ln -sf $opts "$pwd/i3status" "$HOME/.config"
ln -sf $opts "$pwd/zathura" "$HOME/.config"
ln -sf $opts "$pwd/rofi" "$HOME/.config"
ln -sf $opts "$pwd/dunst" "$HOME/.config"
ln -sf $opts "$pwd/termite" "$HOME/.config"
ln -sf $opts "$pwd/vis" "$HOME/.config"
ln -sf $opts "$pwd/compton" "$HOME/.config"
