#! /bin/bash -e

echo 'Installing bat..'

BAT_VERSION=${BAT_VERSION:-0.18.3}

# Install bat package
if ! command -v bat >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armhf
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
if [[ ! -L "$(bat --config-dir)/themes/mafro.tmTheme" ]]; then
	ln -s "$HOME/dotfiles/zsh/bat/mafro.tmTheme" "$(bat --config-dir)/themes"
fi

# Build the bat cache
bat cache --build
