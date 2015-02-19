#! /bin/bash

# retrieve the Vundle submodule
git submodule update --init vim/.vim/bundle/Vundle.vim

# install vim plugins with Vundle
if [[ $? -eq 0 ]]; then
	vim +PluginInstall +qall
fi
