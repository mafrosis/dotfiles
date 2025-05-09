#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# Custom font
if [[ ! -f ~/Library/Fonts/HackNerdFont-Regular.ttf ]]; then
	curl -L -o /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip
	unzip -o -d /tmp /tmp/Hack.zip
	cp /tmp/HackNerdFont-Regular.ttf ~/Library/Fonts
fi

echo "You will need to set the 'Load preferences from a custom folder' option in iterm" 

# skip stow in top-level install.sh
exit 255
