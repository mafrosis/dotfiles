#! /bin/zsh -e

echo 'Installing vivid..'

VIVID_VERSION=${VIVID_VERSION:-0.10.1}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# Install vivid package
if [[ $FORCE -eq 0 ]] && command -v vivid >/dev/null 2>&1; then
	echo 'vivid already installed!'
else
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			curl -o /tmp/vivid.tgz -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid-v${VIVID_VERSION}-arm-unknown-linux-musleabihf.tar.gz
			tar xzf /tmp/vivid.tgz -C /tmp --strip-components=1
			sudo mv /tmp/vivid /usr/bin

		elif [[ $(uname -m) = aarch64 ]]; then
			curl -o /tmp/vivid.deb -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_arm64.deb
			sudo dpkg -i /tmp/vivid.deb

		else
			# Assume amd64 by default
			curl -o /tmp/vivid.deb -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_amd64.deb
			sudo dpkg -i /tmp/vivid.deb
		fi

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install vivid
		echo 'Symlink Homebrew vivid into /usr/local/bin..'
		sudo ln -s $(which vivid) /usr/local/bin/vivid
	fi
fi
