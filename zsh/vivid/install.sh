#! /bin/zsh -e

source ./lib.sh
info '## Setup vivid'

VIVID_VERSION=${VIVID_VERSION:-0.10.1}
TMPDIR=${TMPDIR:-/tmp}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# Install vivid package
if [[ $FORCE -eq 0 ]] && command -v vivid >/dev/null 2>&1; then
	echo 'vivid already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install vivid
	
	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			curl -o ${TMPDIR}/vivid.tgz -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid-v${VIVID_VERSION}-arm-unknown-linux-musleabihf.tar.gz
			tar xzf ${TMPDIR}/vivid.tgz -C ${TMPDIR} --strip-components=1
			sudo mv ${TMPDIR}/vivid /usr/bin

		elif [[ $(uname -m) = aarch64 ]]; then
			curl -o ${TMPDIR}/vivid.deb -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_arm64.deb
			sudo dpkg -i ${TMPDIR}/vivid.deb

		else
			# Assume amd64 by default
			curl -o ${TMPDIR}/vivid.deb -L https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_amd64.deb
			sudo dpkg -i ${TMPDIR}/vivid.deb
		fi

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install vivid
		echo 'Symlink Homebrew vivid into /usr/local/bin..'
		sudo ln -s $(which vivid) /usr/local/bin/vivid
	fi
fi
