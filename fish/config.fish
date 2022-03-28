set -x PATH $HOME/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.yarn/bin $PATH

set -x PATH $HOME/dotfiles/bin $PATH

set -x ANDROID_HOME $HOME/Android/Sdk

set -x PATH $ANDROID_HOME/emulator $PATH
set -x PATH $ANDROID_HOME/tools $PATH
set -x PATH $ANDROID_HOME/tools/bin $PATH
set -x PATH $ANDROID_HOME/platform-tools $PATH

set -x VISUAL "kak"
set -x EDITOR "kak"
set -x LC_CTYPE "en_US.UTF-8"

set fish_greeting ""

function e
    $EDITOR $argv
end

fzf_key_bindings
