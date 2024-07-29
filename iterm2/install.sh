#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# install customised version of Hack font
cp iterm2/HackMafro-Regular.otf /Library/Fonts

echo "You will need to set the 'Load preferences from a custom folder' option in iterm" 

# skip stow in top-level install.sh
exit 255
