#! /bin/zsh

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if ! command -v git >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install git

	elif [[ -n $TERMUX_VERSION ]]; then
		pkg install -y git

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y git
	fi
fi

# install git-delta
source "$(dirname "$0")/delta/install.sh"

# create bin directory in $HOME before stow symlinks into it
mkdir -p "$HOME/.local/bin"
