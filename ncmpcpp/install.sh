#! /bin/bash

if ! command -v brew >/dev/null 2>&1; then
	echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
	exit 3
fi

brew install ncmpcpp
