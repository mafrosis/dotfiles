#! /bin/bash

if [[ -z $(which zsh) ]]; then

	# install ZSH package
	if [[ $(uname) == 'Darwin' ]]; then
		if [[ -z $(which brew) ]] ; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install zsh

	elif [[ $(uname) == 'Linux' ]]; then
		sudo aptitude install zsh
	fi

fi

# update prezto submodule
git submodule update --init --recursive prezto

# manually create symlink to prezto in $HOME
if [[ ! -L ~/.zprezto ]]; then
	ln -s $HOME/dotfiles/prezto $HOME/.zprezto
fi
