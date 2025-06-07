#! /bin/zsh -e

echo 'Installing ripgrep..'

# Install ripgrep package
if command -v rg >/dev/null 2>&1; then
	echo 'ripgrep already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install ripgrep

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y ripgrep

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install ripgrep
	fi
fi
