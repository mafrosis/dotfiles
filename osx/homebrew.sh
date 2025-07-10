#! /bin/bash

source ./lib.sh
info '## Bootstrap Homebrew and install baseline macOS apps'

if [[ $(uname) != 'Darwin' ]] ; then
	echo 'Script only for OSX!';
	exit 44;
fi

function install_homebrew {
	if ! command -v brew >/dev/null 2>&1; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

# install missing Homebrew
install_homebrew

# --init means ensure Homebrew available & exit
if [[ $1 == '--init' ]]; then
	exit 0;
fi

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

# install a few essentials
brew install bash
brew install coreutils
brew install exiftool
brew install fdupes
brew install ffmpeg
brew install gnu-sed
brew install imagemagick
brew install jq
brew install libmagic
brew install mas
brew install nmap
brew install pandoc
brew install screenresolution
brew install shellcheck
brew install inetutils
brew install yt-dlp

# install cask for Chrome, if not already installed
if [[ ! -d /Applications/Google\ Chrome.app ]]; then
	brew install google-chrome
fi

# install cask for iTerm2, if not already installed
if [[ ! -d /Applications/iTerm.app ]]; then
	brew install iterm2
fi

function notarize {
	xattr -r -d com.apple.quarantine "/Applications/$1"
}

# install baseline apps via Cask
brew install 1password
brew install 1password-cli
brew install firefox
brew install google-drive
brew install nordvpn
brew install numi
brew install --cask qlmarkdown && notarize QLMarkdown.app && open /Applications/QLMarkdown.app
brew install qlstephen
brew install qlvideo
brew install raycast
brew install --cask syncthing
brew install syntax-highlight
brew install textmate
brew install vlc

# install Mac App Store apps
if [[ ! -d /Applications/Dato.app ]]; then
	mas install 1470584107 # Dato
fi
if [[ ! -d /Applications/Monodraw.app ]]; then
	mas install 920404675 # Monodraw
fi
if [[ ! -d /Applications/Yomu.app ]]; then
	mas install 562211012 # Yomu ebook reader
fi
if [[ ! -d /Applications/AmorphousDiskMark.app ]]; then
	mas install 1168254295 # AmorphousDiskMark
fi
if [[ ! -d "/Applications/Pixelmator Pro.app" ]]; then
	mas install 1289583905 # Pixelmator Pro
fi


# remove all the dirty temp files
brew cleanup
