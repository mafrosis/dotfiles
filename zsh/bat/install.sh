#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

echo 'Installing bat..'

BAT_VERSION=${BAT_VERSION:-0.25.0}
TMPDIR=${TMPDIR:-/tmp}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

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
			curl -o ${TMPDIR}/bat.deb -L \
				https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-musl_${BAT_VERSION}_arm64.deb
			sudo dpkg -i ${TMPDIR}/bat.deb

		elif [[ $(uname -m) = aarch64 ]]; then
			curl -o ${TMPDIR}/bat.tgz -L \
				https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-aarch64-unknown-linux-musl.tar.gz
			tar xzf ${TMPDIR}/bat.tgz -C ${TMPDIR}
			sudo mv ${TMPDIR}/bat-v${BAT_VERSION}-aarch64-unknown-linux-musl/bat /usr/local/bin

		else
			curl -o ${TMPDIR}/bat.deb -L \
				https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-musl_${BAT_VERSION}_musl-linux-amd64.deb
			sudo dpkg -i ${TMPDIR}/bat.deb
		fi
	fi
fi
bat -V

# Setup custom theme
mkdir -p "$(bat --config-dir)/themes"
ln -sf "$HOME/dotfiles/zsh/bat/mafro.tmTheme" "$(bat --config-dir)/themes"

# Build the bat cache
bat cache --build
