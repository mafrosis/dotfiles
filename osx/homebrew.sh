#! /bin/bash

# Bootstrap Homebrew and install required apps

if [[ $(uname) != 'Darwin' ]] ; then
	echo 'Script only for OSX!';
	exit 44;
fi

function install_homebrew {
	if [[ -z $(which brew) ]] ; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
}

function install_caskroom {
	brew cask &>/dev/null
	if [[ $? -eq 1 ]] ; then
		brew install caskroom/cask/brew-cask
	fi
	if [[ -z $(brew tap | grep caskroom/versions) ]]; then
		brew tap caskroom/versions
	fi
}

# install missing Homebrew & Caskroom
install_homebrew
install_caskroom

# --init means ensure Homebrew available & exit
if [[ $1 == '--init' ]]; then
	exit 0;
fi

# install a few essentials
brew install \
	bash \
	coreutils \
	ffmpeg --with-faac \
	lame \
	python --with-frameworks \
	unrar

# install baseline apps via Cask
brew cask install \
	android-file-transfer \
	dropbox \
	google-chrome \
	google-drive \
	iterm2 \
	keepassx \
	textmate
