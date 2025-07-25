#! /bin/zsh -e

source ./lib.sh
info '## Setup wakeonlan'

# Install wakeonlan package
if ! command -v wakeonlan >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install wakeonlan

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y wakeonlan
	fi
fi
