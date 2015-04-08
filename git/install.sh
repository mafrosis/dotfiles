#! /bin/bash

if [[ -z $(which git) ]]; then

	# install git package
	if [[ $(uname) == 'Darwin' ]]; then
		if [[ -z $(which brew) ]] ; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install git

	elif [[ $(uname) == 'Linux' ]]; then
		sudo aptitude install git
	fi

fi

# create bin directory in $HOME before stow symlinks into it
if [[ ! -d $HOME/bin ]]; then
	mkdir $HOME/bin
fi
