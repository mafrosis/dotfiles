# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=erasedups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# mafro- some more ls aliases
alias ll='ls -lh'
alias la='ls -Alh'
alias lh='ls -ld .??*'

# mafro- simple temperature check
alias temp='sensors | grep "Core0 Temp*"'

# mafro- diskspace alias
alias duh='du -h --max-depth=1'

# mafro- mcp alias for multiple file copy
alias mcp='mmv -c'

# enable programmable completion features
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# git alias
alias gs='git status'
alias gb='git branch --color -a'

# http://gist.github.com/31631

function parse_git_dirty {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

# color my prompt including git info
export PS1='\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w \[\033[1;33m\]$(parse_git_branch)\[\033[00m\]> '

# allow bash color in less output
LESS=-r

# prevent ctrl-s disabling terminal flow control (XOFF)
stty ixany


