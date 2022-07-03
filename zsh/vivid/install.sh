#! /bin/bash -e

echo 'Installing vivid..'

# Install vivid package
if ! command -v vivid >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			curl -o /tmp/vivid.tgz -L https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid-v0.8.0-arm-unknown-linux-musleabihf.tar.gz
			tar xzf /tmp/vivid.tgz -C /tmp --strip-components=1
			sudo mv /tmp/vivid /usr/bin
		else
			# Assume amd64 by default
			curl -o /tmp/vivid.deb -L https://github.com/sharkdp/vivid/releases/download/v0.8.0/vivid_0.8.0_amd64.deb
			sudo dpkg -i /tmp/vivid.deb
		fi

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install vivid
		echo 'Symlink Homebrew vivid into /usr/local/bin..'
		sudo ln -s "$(which vivid)" /usr/local/bin
	fi
fi
