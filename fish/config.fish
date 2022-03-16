set PATH $HOME/bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.yarn/bin $PATH

set PATH $HOME/dotfiles/bin $PATH

set ANDROID_HOME $HOME/Android/Sdk

set PATH $ANDROID_HOME/emulator $PATH
set PATH $ANDROID_HOME/tools $PATH
set PATH $ANDROID_HOME/tools/bin $PATH
set PATH $ANDROID_HOME/platform-tools $PATH

set VISUAL "kak"
set EDITOR "kak"
set LC_CTYPE "en_US.UTF-8"

set fish_greeting ""

function e
    $EDITOR $argv
end

fzf_key_bindings

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

