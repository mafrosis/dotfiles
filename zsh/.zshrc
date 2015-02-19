# :D
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

########### Globals ######################################
#
# don't write history immediately; wait until exit
setopt NO_INC_APPEND_HISTORY
# don't share history between concurrent shells
setopt NO_SHARE_HISTORY

# prevent 'vim' -> '.vim'
setopt NOCORRECTALL

# a nice plain green grep highlight
export GREP_COLOR='33;92'

# PATH
export PATH=$HOME/bin:/usr/local/share/python:$PATH

########### Aliases / Functions ###########################

# import aliases
if [ -f $HOME/.zsh_aliases ]; then
	source $HOME/.zsh_aliases
fi

# add custom functions to the FPATH
# http://unix.stackexchange.com/a/33898
fpath=( ~/.zsh-functions "${fpath[@]}" )

# autoload custom functions..
for func in $(ls ~/.zsh-functions); do
	autoload -Uz $func
done

########## Exports ########################################

# enable OSX alt-arrow word nav
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
# custom iterm2 binding to alt-backspace
bindkey '^[[1;9X' backward-delete-word

#################### Exports ####################

# Homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Android
export ANDROID_HOME=~/Development/android/android-sdk-macosx
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

# ebook stuff
export EBOOK_HOME=~"/Documents/ebooks/DeDRM"
export EBOOK_USER=mafro
export EBOOK_PASS=eggs

export MUSIC_DIR="/home/mafro/mp3/mp3"

export EDITOR=vim
export VISUAL=vim

export TERM=xterm-256color

# Golang via homebrew
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin

# Python shell
export PYTHONSTARTUP="$HOME/.pythonstartup.py"

# tmux-powerline
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
PLATFORM="linux"

# use vmware in vagrant
export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
export VAGRANT_VMWARE_CLONE_DIRECTORY="~/.vagrant.d/machines"

# since root inherits $PATH on Debian now with env_keep in sudoers, need /sbin in $PATH
export PATH=$PATH:/sbin
