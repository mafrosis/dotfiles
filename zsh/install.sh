#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# install ZSH package
if ! command -v zsh >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install zsh
		sudo chsh -s /bin/zsh

		# Ensure /usr/local/bin, missing on new macOS
		if [[ ! -d /usr/local/bin ]]; then
			sudo mkdir /usr/local/bin
		fi

	elif [[ -n $TERMUX_VERSION ]]; then
		pkg install -y zsh
		chsh -s /bin/zsh

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y zsh
		sudo usermod -s /bin/zsh "$(whoami)"
	fi
fi

# install bat, vivid, ag, fd, duf, fzf everywhere
source "$(dirname "$0")/bat/install.sh"
source "$(dirname "$0")/vivid/install.sh"
source "$(dirname "$0")/ripgrep/install.sh"
source "$(dirname "$0")/fd/install.sh"
source "$(dirname "$0")/duf/install.sh"
source "$(dirname "$0")/fzf/install.sh"

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
