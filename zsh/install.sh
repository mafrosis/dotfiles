#! /bin/bash -e

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo'
else
	SUDO=''
fi

if ! command -v zsh >/dev/null 2>&1; then

	# install ZSH package
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install zsh
		$SUDO chsh -s /bin/zsh "$(whoami)"

	elif [[ $(uname) == 'Linux' ]]; then
		$SUDO apt-get install -y zsh
		$SUDO usermod -s /bin/zsh "$(whoami)"
	fi

fi

# special case for root: need copy of dotfiles in root's $HOME
if [[ $(id -u) -eq 0 ]] && [[ ! -d /root/dotfiles ]]; then
	git clone --recursive https://github.com/mafrosis/dotfiles.git /root/dotfiles
fi

# update prezto submodule
git submodule update --init --recursive prezto

# manually create symlink to prezto in $HOME
if [[ ! -L ~/.zprezto ]]; then
	ln -s "$HOME/dotfiles/prezto" "$HOME/.zprezto"
fi
