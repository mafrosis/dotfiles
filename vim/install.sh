#! /bin/bash

# retrieve the Vundle submodule
git submodule update --init vim/.vim/bundle/Vundle.vim

# install vim plugins with Vundle
if [[ $? -eq 0 ]]; then
	# if either stdin or stdout is missing, redirect output
	if [[ ! -t 0 || ! -t 1 ]]; then
		vim +PluginInstall +qall &>/dev/null
	else
		vim +PluginInstall +qall
	fi
fi
