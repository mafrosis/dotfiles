#! /bin/bash

# Bootstrap Homebrew and install required apps

if [[ $(uname) != 'Darwin' ]] ; then
	echo 'Script only for OSX!';
	exit 44;
fi

function install_homebrew {
	if ! command -v brew >/dev/null 2>&1; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# install missing Homebrew
install_homebrew

# --init means ensure Homebrew available & exit
if [[ $1 == '--init' ]]; then
	exit 0;
fi

# install a few essentials
brew install \
	axel \
	bash \
	coreutils \
	exiftool \
	fdupes \
	ffmpeg \
	gnu-sed \
	httpie \
	imagemagick \
	jq \
	libmagic \
	mas \
	m-cli \
	mercurial \
	nmap \
	pandoc \
	screenresolution \
	shellcheck \
	inetutils \
	terminal-notifier \
	yt-dlp

# install cask for Chrome, if not already installed
if [[ ! -d /Applications/Google\ Chrome.app ]]; then
	brew install google-chrome
fi

# install cask for iTerm2, if not already installed
if [[ ! -d /Applications/iTerm.app ]]; then
	brew install iterm2
fi

# install baseline apps via Cask
brew install \
	1password \
	1password-cli \
	android-file-transfer \
	bartender \
	daisydisk \
	drawio \
	firefox \
	google-drive \
	keepassx \
	nordvpn \
	qlstephen \
	qlcolorcode \
	qlvideo \
	raycast \
	syncthing \
	textmate \
	vlc

# install Mac App Store apps
mas install 1470584107 # Dato
mas install 920404675 # Monodraw
mas install 562211012 # Yomu ebook reader
mas install 1168254295 # AmorphousDiskMark
mas install 1289583905 # Pixelmator Pro
mas install 920404675 # Monodraw


# remove all the dirty temp files
brew cleanup
