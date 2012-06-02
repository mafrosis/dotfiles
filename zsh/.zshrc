# Path to your oh-my-zsh configuration.
ZSH=$HOME/dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mafro"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git python osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# advanced file globbing
setopt extended_glob

# enable OSX alt-arrow word nav
bindkey '' forward-word
bindkey '' backward-word

# ignore history duplicates
setopt hist_ignore_all_dups

# prevent 'vim' -> '.vim'
setopt nocorrectall

# MacPorts
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# PATH
export PATH=$HOME/bin:$PATH
export PATH=~/Development/android/android-sdk-mac_x86/tools:~/Development/android/android-sdk-mac_x86/platform-tools:$PATH

# ebook stuff
export EBOOK_HOME=~"/Documents/ebooks/DeDRM"
export EBOOK_USER=mafro
export EBOOK_PASS=eggs1bacon4

export EDITOR=vim


