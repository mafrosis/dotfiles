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


########## Completion Extensions ##########################

zstyle ':completion:*:(gvim|vim|vi):*' ignored-patterns '*.(o|a|so|swp|idx|out|toc|class|pdf|pyc|mp4|mkv|avi|mp3|flac|jpg|jpeg|gif|png)|__pycache__'


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

# nvm
#export NVM_DIR="$HOME/.nvm"
#. "/usr/local/opt/nvm/nvm.sh"


########## Exports ########################################

# Homebrew AND since root inherits $PATH on Debian now with env_keep in sudoers, need /sbin in $PATH
export PATH=$PATH:$HOME/.local/bin

export EDITOR=vim
export VISUAL=vim

export TERM=xterm-256color

# Golang via homebrew
export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin

# no virtualenv prompt; shown via prezto theme
export VIRTUAL_ENV_DISABLE_PROMPT=1

# use vmware in vagrant / packer
export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
export VAGRANT_VMWARE_CLONE_DIRECTORY="~/.vagrant.d/machines"

# gcloud CLI
export PATH=$PATH:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin

# fix the whacky coreutils ls quoting change - http://unix.stackexchange.com/a/262162/8504
export QUOTING_STYLE=literal ls

# Docker exports
export MACHINE_DRIVER=vmwarefusion

# awscli and friends
export AWS_DEFAULT_REGION=eu-west-1
