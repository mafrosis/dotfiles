#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

echo 'Installing bat..'

BAT_VERSION=${BAT_VERSION:-0.22.1}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# Install bat package
if [[ $FORCE -eq 0 ]] && command -v bat >/dev/null 2>&1; then
	echo 'bat already installed!'
else
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armhf
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o /tmp/bat.deb -L "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCH}.deb"
		sudo dpkg -i /tmp/bat.deb

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install bat
	fi
fi

# Setup custom theme
mkdir -p "$(bat --config-dir)/themes"
ln -sf "$HOME/dotfiles/zsh/bat/mafro.tmTheme" "$(bat --config-dir)/themes"

# Build the bat cache
bat cache --build
