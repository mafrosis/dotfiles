#! /bin/bash -e

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo'
else
	SUDO=''
fi

# install vim package
if [[ $(uname) == 'Linux' ]]; then

	if ! command -v vim >/dev/null 2>&1; then
		if [[ $(uname) =~ (.*)Debian(.*) ]]; then
			$SUDO apt-get install -y vim-nox
		elif [[ $(uname) =~ (.*)Ubuntu(.*) ]]; then
			$SUDO apt-get install -y vim
		elif [[ $(uname) =~ (.*)Linux(.*) ]]; then
			$SUDO apt-get install -y vim-nox
		fi
	fi

elif [[ $(uname) == 'Darwin' ]] && ! brew list | grep -q vim; then
	brew install vim
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
mkdir -p ~/.vim/undodir
