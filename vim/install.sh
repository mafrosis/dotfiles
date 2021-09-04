#! /bin/bash -e

# install vim package
if ! command -v vim >/dev/null 2>&1; then
	if [[ $(uname) == Linux ]]; then
		sudo apt-get install -y vim-nox
	elif [[ $(uname) == 'Darwin' ]]; then
		brew install vim
	fi
fi

# retrieve the Vundle submodule & install vim plugins with Vundle
if git submodule update --init vim/.vim/bundle/Vundle.vim; then
	# if either stdin or stdout is missing, redirect output
	if [[ ! -t 0 || ! -t 1 ]]; then
		vim +PluginInstall +qall &>/dev/null
	else
		vim +PluginInstall +qall
	fi
fi

# Create the persistent undo dir
mkdir -p ~/.vim-undo
