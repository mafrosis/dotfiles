# vim: ft=zsh
#
# Defines the shell helpers and options for typical CLI usage.
# Loaded by all interactive shells.
#
# Authors:
#   Matt Black <dev@mafro.net>
#

# LS_COLORS with a custom theme
# export this before prezto is loaded, to ensure it's baked into zcompinit
if command -v vivid >/dev/null 2>&1; then
	export LS_COLORS="$(vivid generate ${HOME}/dotfiles/zsh/vivid/lscolors.yml)"
fi

# :D
if [[ -s ${HOME}/.zprezto/init.zsh ]]; then
  source ${HOME}/.zprezto/init.zsh
fi

# Starship
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init zsh)"
fi


########### Globals ######################################

# don't share history between concurrent shells
setopt NO_SHARE_HISTORY

# prevent 'vim' -> '.vim'
# https://superuser.com/a/610025
unsetopt correct_all
setopt correct

# don't automatically change directories
unsetopt AUTO_CD

# a nice plain green grep highlight
export GREP_COLOR='33;92'           # BSD
export GREP_COLORS="mt=$GREP_COLOR" # GNU


########### Aliases / Functions ###########################

# import aliases
if [[ -f ${HOME}/.zsh_aliases ]]; then
	source ${HOME}/.zsh_aliases
fi

# add custom functions to the FPATH
# http://unix.stackexchange.com/a/33898
fpath=( ~/.zsh-functions "${fpath[@]}" )

# autoload custom functions..
for func in $(/bin/ls ~/.zsh-functions); do
	autoload -Uz "$func"
done


########## Completion #####################################

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

# junegunn/fzf
export PATH=${PATH}:${HOME}/dotfiles/zsh/fzf/external/bin

export FZF_DEFAULT_OPTS='--height=40%'

source ${HOME}/dotfiles/zsh/fzf/external/shell/completion.zsh
source ${HOME}/dotfiles/zsh/fzf/external/shell/key-bindings.zsh

alias fvim='vim $(fzf)'

if [[ -d ${HOME}/.step/zsh_completion ]]; then
	source ${HOME}/.step/zsh_completion
fi

# llm.datasette.io
export LLM_USER_PATH=~/.config/io.datasette.llm
