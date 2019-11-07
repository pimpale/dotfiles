#!/bin/zsh

opts=$@

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

ln -s $opts "$pwd/zshrc" "$HOME/.zshrc"
ln -s $opts "$pwd/nvim" "$HOME/.config"
ln -s $opts "$pwd/kak" "$HOME/.config"
ln -s $opts "$pwd/i3" "$HOME/.config"
ln -s $opts "$pwd/i3status" "$HOME/.config"
ln -s $opts "$pwd/zathura" "$HOME/.config"
ln -s $opts "$pwd/rofi" "$HOME/.config"
ln -s $opts "$pwd/dunst" "$HOME/.config"
ln -s $opts "$pwd/termite" "$HOME/.config"
ln -s $opts "$pwd/vis" "$HOME/.config"
ln -s $opts "$pwd/compton" "$HOME/.config"
