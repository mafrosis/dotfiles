#! /bin/bash -e

echo 'Installing duf..'

DUF_VERSION=${DUF_VERSION:-0.6.2}

# Install duf package
if ! command -v duf >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armv7
		else
			ARCH=amd64
		fi
		curl -o /tmp/duf.deb -L "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${ARCH}.deb"
		sudo dpkg -i /tmp/duf.deb

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install duf
	fi
fi
