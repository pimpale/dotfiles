#!/bin/zsh

pwd="$HOME/dotfiles"
mkdir "$HOME/.config"

install_to() {
  ln -sf $opts "$pwd/$1" "$HOME/$2"
}

install() {
  install_to $1 ".config"
}

# special
install_to zshrc .zshrc

# regulars
install nvim
install kak
install kak-lsp
install i3
install i3status
install zathura
install rofi
install dunst
install termite
install vis
install bspwm
install sxhkd
