# Load .bash_profile
if [ -f ~/.bash_profile ]; then 
    . ~/.bash_profile;
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# install oh-my-zsh if it doesn't exist
  if [ ! -d "$ZSH" ]; then
    # Uncomment the following line to install oh-my-zsh
    # sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  else 
    # Set name of the theme to load. Optionally, if you set this to "random"
      # it'll load a random theme each time that oh-my-zsh is loaded.
      # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
      ZSH_DISABLE_COMPFIX="true"
      ZSH_THEME="eastwood"
      # Set list of themes to load
      # Setting this variable when ZSH_THEME=random
      # cause zsh load theme from this variable instead of
      # looking in ~/.oh-my-zsh/themes/
      # An empty array have no effect
      # ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" 

  # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion. Case
  # sensitive completion must be off. _ and - will be interchangeable.
  # HYPHEN_INSENSITIVE="true"

  # Uncomment the following line to disable bi-weekly auto-update checks.
  # DISABLE_AUTO_UPDATE="true"

  # Uncomment the following line to change how often to auto-update (in days).
  # export UPDATE_ZSH_DAYS=13

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
    COMPLETION_WAITING_DOTS="true"

  # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
      # much, much faster.
      # DISABLE_UNTRACKED_FILES_DIRTY="true"

  # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # HIST_STAMPS="mm/dd/yyyy"

  # Would you like to use another custom folder than $ZSH/custom?
  # ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.

  plugins=(
    git
    fzf
    archlinux
  )

  source $ZSH/oh-my-zsh.sh
fi

# React Native
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/compilers/bin"
export PATH=$PATH:"$HOME/.local/bin"

# virtualenv
if hash virtualenvwrapper.sh 2> /dev/null; then 
  export WORKON_HOME=$HOME/.virtualenvs
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
  source virtualenvwrapper.sh
fi

#My favorites
export VISUAL="nvim"
export EDITOR="nvim"
export LC_CTYPE=en_US.UTF-8
bindkey -e

#add our scripts to el path
export PATH=$PATH:"$HOME/dotfiles/bin"


#for our good old linux box
  alias wol-t4700="wol 66:66:66:66:66:66"

# XTERM
if [ "$TERM" = "xterm-termite" ]; then 
  export TERM="rxvt-256color"
fi

#when on ubuntu
if grep -q ubuntu /etc/os-release; then
  alias pacman="sudo pacapt"
fi

#helpfulness
alias rm="rm -i"
alias cp="cp -r"

#misspellings
alias sduo=sudo
alias sdudo=sudo
alias sudi=sudo
alias clea=clear
alias ncim=nvim
alias nivm=nvim
alias vnim=nvim
alias nvmi=nvim
alias ezec="exec"
alias sl="ls"
alias s="ls"
alias ks="ls"
alias lss="ls"
alias sls="ls"
alias ls-a="ls -a"
alias scd=cd
alias "cd.."="cd .."
alias mdkir=mkdir
alias ,,=..
alias wget-recursive-get="wget -r -nH --cut-dirs=2 --no-parent"

#plan 9 is the superior operating system
unalias 9
export PLAN9="/lib/plan9"
export PATH=$PATH:$PLAN9/bin
