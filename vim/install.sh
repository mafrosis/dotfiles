#! /bin/zsh -e

source ./lib.sh
info '## Setup vim'

if [[ -n $TERMUX_VERSION ]]; then
	pkg install -y vim

elif [[ $(uname) == Linux ]]; then
	if ! command -v vim >/dev/null 2>&1; then
		sudo apt-get install -y vim-nox
	fi

elif [[ $(uname) == 'Darwin' ]]; then
	# Use Homebrew vim over Apple vim (for +termguicolors)
	if vim --version | grep -q 'macOS version'; then
		brew install vim

		if [[ ! -L /usr/local/bin/vim ]]; then
			sudo ln -sf /opt/homebrew/bin/vim /usr/local/bin
		fi
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
