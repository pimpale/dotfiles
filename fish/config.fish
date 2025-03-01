set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.elan/bin $PATH
set -x PATH /opt/cuda/bin $PATH
set -x PATH /opt/google-cloud-cli/bin $PATH
set -x PATH /usr/local/cuda/bin $PATH
set -x PATH $HOME/bin $PATH

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

set -x DEBUGINFOD_URLS "https://debuginfod.archlinux.org"

#fzf_key_bindings

function ci
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/miniconda3/bin/conda
    eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
end

function ci2
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/anaconda/bin/conda
    eval /opt/anaconda/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
end

function ci3
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/conda/bin/conda
    eval /opt/conda/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
end
