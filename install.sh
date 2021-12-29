#!/bin/sh

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

install_to() {
  ln -sf $opts "$pwd/$1" "$HOME/$2"
}

install() {
  install_to $1 ".config"
}

install_to etc/.pam_environment .
install_to etc/.xinitrc .

# regulars
install nvim
install helix
install kak
install kak-lsp
install i3
install i3status
install zathura
install rofi
install dunst
install alacritty
install vis
install picom
install tmux
install fish
install sway
install nix
