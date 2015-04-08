#! /bin/bash

# create bin directory in $HOME before stow symlinks into it
if [[ ! -d $HOME/bin ]]; then
	mkdir $HOME/bin
fi
