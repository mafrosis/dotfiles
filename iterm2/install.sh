#! /bin/bash -e

# install customised version of Hack font
cp iterm2/HackMafro-Regular.otf /Library/Fonts

echo "You will need to set the 'Load preferences from a custom folder' option in iterm" 

# skip stow in top-level install.sh
exit 255
