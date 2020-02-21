#! /bin/bash -e

# bail if not Darwin
if [[ $(uname) != 'Darwin' ]] ; then
	echo 'Currently only implemented for macOS'
	exit 255
fi

function install_homebrew {
	if ! command -v brew >/dev/null 2>&1; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
}

# install missing Homebrew
install_homebrew

brew cask install docker

# skip stow in top-level install.sh
exit 255
