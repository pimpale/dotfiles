set -x PATH $HOME/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.elan/toolchains/leanprover--lean4---nightly/bin $PATH
set -x PATH /opt/cuda/bin $PATH
set -x PATH /usr/local/cuda/bin $PATH

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

function ci
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
