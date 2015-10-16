# :D
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


########### Globals ######################################

# don't write history immediately; wait until exit
setopt NO_INC_APPEND_HISTORY
# don't share history between concurrent shells
setopt NO_SHARE_HISTORY

# prevent 'vim' -> '.vim'
setopt NOCORRECTALL

# don't automatically change directories
unsetopt AUTO_CD

# a nice plain green grep highlight
export GREP_COLOR='33;92'           # BSD
export GREP_COLORS="mt=$GREP_COLOR" # GNU

# PATH
export PATH=$HOME/bin:/usr/local/share/python:$PATH


########### NTPd hack #####################################

# sometimes ntpd is dead on VMs, causing bad git commit timestamps
if [[ -x /etc/init.d/ntp ]]; then
	# ensure user can sudo without password
	if [[ -z $(sudo -l -n | grep 'password is required') ]]; then
		# check ntpd status
		sudo /etc/init.d/ntp status >/dev/null
		if [[ $? -gt 0 ]]; then
			sudo /etc/init.d/ntp start
		fi
	fi
fi


########### Aliases / Functions ###########################

# import aliases
if [[ -f $HOME/.zsh_aliases ]]; then
	source $HOME/.zsh_aliases
fi

# add custom functions to the FPATH
# http://unix.stackexchange.com/a/33898
fpath=( ~/.zsh-functions "${fpath[@]}" )

# autoload custom functions..
for func in $(ls ~/.zsh-functions); do
	autoload -Uz $func
done


########## Bindkey ########################################

# enable OSX alt-arrow word nav
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# fix HOME/END for xterm config in iterm2
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

# custom iterm2 binding to alt-backspace
bindkey '^[[1;9X' backward-delete-word


########## Third-party ####################################

# rupa/z
. ~/dotfiles/bin/z/z.sh


########## Exports ########################################

# Homebrew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Android
export ANDROID_HOME=/usr/local/opt/android-sdk
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

# no virtualenv prompt; shown via prezto theme
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Python shell
export PYTHONSTARTUP="$HOME/.pythonstartup.py"

# tmux-powerline
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
PLATFORM="linux"

# use vmware in vagrant / packer
export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
export VAGRANT_VMWARE_CLONE_DIRECTORY="~/.vagrant.d/machines"
export VAGRANT_VMWARE_FUSION_APP="/Users/mafro/Applications/VMware Fusion.app"
export FUSION_APP_PATH="/Users/mafro/Applications/VMware Fusion.app"

# since root inherits $PATH on Debian now with env_keep in sudoers, need /sbin in $PATH
export PATH=$PATH:/sbin
