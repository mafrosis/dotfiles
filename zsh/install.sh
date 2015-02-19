#! /bin/bash

# update prezto submodule
git submodule update --init --recursive prezto

# manually create symlink to prezto in $HOME
if [[ ! -L ~/.zprezto ]]; then
	ln -s $HOME/dotfiles/prezto $HOME/.zprezto
fi
