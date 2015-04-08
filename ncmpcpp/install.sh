#! /bin/bash

if [[ -z $(which brew) ]]; then
	echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
	exit 3
fi

brew install ncmpcpp
