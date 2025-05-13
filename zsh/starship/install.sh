#! /bin/zsh -e

source ./lib.sh
info '## Setup starship'

# Install starship package
if [[ $FORCE -eq 0 ]] && command -v starship >/dev/null 2>&1; then
	echo 'starship already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install getconf
		curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir /data/data/com.termux/files/usr/bin

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt install -y starship

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install starship
	fi
fi

# Setup config
ln -sf $HOME/dotfiles/zsh/starship/.config/starship.toml $HOME/.config/starship.toml
