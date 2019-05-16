#! /bin/bash -e

# create bin directory in $HOME before stow symlinks it
if [[ ! -d $HOME/bin ]]; then
	mkdir $HOME/bin
fi
