#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

echo 'Installing duf..'

DUF_VERSION=${DUF_VERSION:-0.8.1}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# Install duf package
if [[ $FORCE -eq 0 ]] && command -v duf >/dev/null 2>&1; then
	echo 'duf already installed!'
else
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armv7
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o /tmp/duf.deb -L "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${ARCH}.deb"
		sudo dpkg -i /tmp/duf.deb

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install duf
	fi
fi
