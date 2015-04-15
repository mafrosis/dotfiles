#! /bin/bash

# install vim package
if [[ $(uname) == 'Linux' && -z $(which vim) ]]; then

	if [[ $(uname) =~ '(.*)Debian(.*)' ]]; then
		sudo aptitude install vim-nox
	elif [[ $(uname) =~ '(.*)Ubuntu(.*)' ]]; then
		sudo aptitude install vim
	fi

elif [[ $(uname) == 'Darwin' && -z $(brew list | grep vim) ]]; then
	brew install vim
fi

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
