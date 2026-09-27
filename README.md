# dotfiles
My configs.

# Requirements
Necessary:
Linux system.
Optional:
htop
zathura
i3
i3status
nvim
zsh


# Installation Instructions
Download folder to your home folder. 
Run install.sh (NOT as root)
This will symlink the necessary files to the necessary locations. The first time you run zsh, it will also attempt to install oh-my-zsh onto your system. The first time you open nvim, it will attempt to install all packages. 

## Sway screenshots

Mod+Shift+C opens `xfce4-screenshooter` interactively. After capture, choose
**Custom action → Copy to clipboard (Wayland)**, then paste into another app.
Screenshooter uses a temporary file; no manual save is needed.

Install `xfce4-screenshooter`, `wl-clipboard` (provides `wl-copy`), and Xfce's
`xfconf` tools (provides `xfconf-query`). Run `install.sh` as your desktop user
in a running desktop session to register the action. To configure just this
feature, run `sh bin/configure_screenshooter.sh` from this repo.
Rerunning setup updates this named action and preserves other custom actions.
