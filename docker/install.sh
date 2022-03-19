#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if ! command -v docker >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install homebrew/cask/docker

	elif [[ $(uname) == 'Linux' ]]; then
		curl -fsSL https://get.docker.com | sudo bash
	fi
fi

# skip stow in top-level install.sh
exit 255
