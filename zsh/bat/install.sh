#! /bin/zsh -e

source ./lib.sh
info '## Setup bat'

BAT_VERSION=${BAT_VERSION:-0.25.0}
TMPDIR=${TMPDIR:-/tmp}

# Install bat package
if [[ $FORCE -eq 0 ]] && command -v bat >/dev/null 2>&1; then
	echo 'bat already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install bat

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install bat

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) = arm64 ]]; then
			FILE=bat_${BAT_VERSION}_arm64.deb

		elif [[ $(uname -m) = aarch64 ]]; then
			# rpi4, rpi zero2
			FILE=bat_${BAT_VERSION}_arm64.deb

		elif [[ $(uname -m) = armv7l ]]; then
			# rpi3
			FILE=bat_${BAT_VERSION}_armhf.deb

		else
			FILE=bat_${BAT_VERSION}_amd64.deb
		fi

		curl -o ${TMPDIR}/bat.deb -L \
			https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${FILE}
		sudo dpkg -i ${TMPDIR}/bat.deb
	fi
fi
bat -V

# Setup custom theme
mkdir -p "$(bat --config-dir)/themes"
ln -sf "$HOME/dotfiles/zsh/bat/mafro.tmTheme" "$(bat --config-dir)/themes"

# Build the bat cache
bat cache --build
