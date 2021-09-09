#! /bin/bash

# Bootstrap Homebrew and install required apps

if [[ $(uname) != 'Darwin' ]] ; then
	echo 'Script only for OSX!';
	exit 44;
fi

function install_homebrew {
	if ! command -v brew >/dev/null 2>&1; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
}

# install missing Homebrew
install_homebrew

# --init means ensure Homebrew available & exit
if [[ $1 == '--init' ]]; then
	exit 0;
fi

# install a few essentials
brew install \
	awscli \
	axel \
	bash \
	coreutils \
	exiftool \
	fdupes \
	ffmpeg \
	flac \
	fzf \
	gnu-sed \
	httpie \
	imagemagick \
	jq \
	lame \
	libmagic \
	nmap \
	nvm \
	mas \
	m-cli \
	mercurial \
	mplayer \
	pandoc \
	python \
	python3 \
	pyenv \
	shellcheck \
	terminal-notifier \
	unrar \
	wakeonlan \
	youtube-dl

# symlink a couple of missing shell commands from GNU coreutils
if [[ ! -L /usr/local/bin/tac ]]; then
	ln -s /usr/local/bin/gtac /usr/local/bin/tac
fi

# install cask for Chrome, if not already installed
if [[ ! -d /Applications/Google\ Chrome.app ]]; then
	brew cask install google-chrome
fi

# install cask for iTerm2, if not already installed
if [[ ! -d /Applications/iTerm.app ]]; then
	brew cask install iterm2
fi

# install baseline apps via Cask
brew cask install \
	1password 1password-cli \
	android-file-transfer \
	dropbox \
	firefox \
	google-backup-and-sync \
	keepassx \
	qlstephen \
	skype \
	textmate \
	vlc

# remove all the dirty temp files
brew cleanup
