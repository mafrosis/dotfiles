#! /bin/bash

# install git package
if ! command -v git >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install git

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install git
	fi
fi

# create bin directory in $HOME before stow symlinks into it
mkdir -p "$HOME/.local/bin"
