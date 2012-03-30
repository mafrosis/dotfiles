# zsh specific
autoload -U compinit
compinit

setopt correctall
setopt autocd
setopt auto_resume
setopt extended_glob

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# history
setopt hist_ignore_all_dups
HISTFILE=~/.zsh-histfile
HISTSIZE=1000
SAVEHIST=1000


# aliases
alias ll="ls -lH"
alias la="ls -laH"
alias tsl="tail -f /var/log/syslog"
alias t="todo.sh"
alias grep="grep --color=auto"
alias lame="nocorrect lame"

# git alias
alias gs='git status'
alias gb='git branch --color -a'

# http://gist.github.com/31631

setopt PROMPT_SUBST

# Autoload zsh functions.
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

#parse_git_dirty() {
#    if [ "$(git status 2> /dev/null | tail -n1)" != "nothing to commit (working directory clean)" ]; then echo "*"; fi
#}
#parse_git_branch() {
#    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
#}

PROMPT="%B%{%F{cyan}%}%n@%m%b%{%F{white}%}:%{%F{cyan}%}%~$(prompt_git_info) %b%{%F{white}%}> "

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


# OSX colors
export LS_OPTIONS='--color=auto'
export CLICOLOR='Yes'
export LSCOLORS='Bxgxfxfxcxdxdxhbadbxbx'


