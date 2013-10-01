# path to your oh-my-zsh configuration.
ZSH=$HOME/dotfiles/oh-my-zsh
ZSH_THEME="mafro"

# case-sensitive completion
CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"

# PATH
export PATH=$HOME/bin:/usr/local/share/python:$PATH
# Homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# use zsh's ace renaming tool
autoload zmv

##### plugins #####
# brew: completion
# celery: completion
# git: completion and fancy prompt
# jump: http://bit.ly/1cLyE9Q
# pip: completion
# python: provides, pyfind, pyclean & pygrep
# osx: finder funcs; most usefully trash
# supervisor: completion
# tmux: auto-start and attach
# vagrant: completion
# virtualenvwrapper auto-activates venv in project directory

plugins=(celery git jump pip python supervisor vagrant virtualenvwrapper)

# I don't use tmux in iTerm2
if [ "$(uname)" != "Darwin" ]; then
	plugins+=(tmux)
else
	plugins+=(brew osx)
fi

# :D
source $ZSH/oh-my-zsh.sh

# import aliases
if [ -f $HOME/.zsh_aliases ]; then
	source $HOME/.zsh_aliases
fi

# add custom functions to the FPATH
# http://unix.stackexchange.com/a/33898
fpath=( ~/.zsh-functions "${fpath[@]}" )

# autoload custom functions..
autoload -Uz uptime
autoload -Uz duh
autoload -Uz today
autoload -Uz f


# advanced file globbing
setopt extended_glob

# enable OSX alt-arrow word nav
bindkey '' forward-word
bindkey '' backward-word

# ignore history duplicates
setopt hist_ignore_all_dups
setopt append_history no_inc_append_history no_share_history

# prevent 'vim' -> '.vim'
setopt nocorrectall

# Android
export ANDROID_HOME=~/Development/android/android-sdk-macosx
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# ebook stuff
export EBOOK_HOME=~"/Documents/ebooks/DeDRM"
export EBOOK_USER=mafro
export EBOOK_PASS=eggs1bacon4

export MUSIC_DIR="/home/mafro/MP3"

export EDITOR=vim

export TERM=xterm-256color

# Go on Chromebook
export PATH=$PATH:~/src/go/bin

# Python shell
export PYTHONSTARTUP="$HOME/.pythonstartup.py"

# tmux-powerline
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
PLATFORM="linux"

# use vmware in vagrant
export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"

# RVM
PATH=$PATH:$HOME/.rvm/bin
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
