# some more ls aliases
alias ll='ls -lh'
alias la='ls -Alh'
alias lh='ls -ld .??*'

# simple temperature check
alias temp='sensors | grep "Core0 Temp*"'

# diskspace alias
alias duh='du -h --max-depth=1'

# git status alias
alias gs='git status'

# mad typo fix
alias exity='exit'

# info with imagemagick
alias imginfo="identify -format '-- %f -- \nType: %m\nSize: %b bytes\nResolution: %wpx x %hpx\nColors: %k'"
alias imgres="identify -format '%f: %wpx x %hpx'"

