#! /bin/bash

# install missing Homebrew
if [[ $(uname) == 'Darwin' && -z $(which brew) ]] ; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
