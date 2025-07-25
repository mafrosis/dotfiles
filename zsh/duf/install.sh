#! /bin/zsh -e

source ./lib.sh
info '## Setup duf'

DUF_VERSION=${DUF_VERSION:-0.8.1}
TMPDIR=${TMPDIR:-/tmp}

# Install duf package
if [[ $FORCE -eq 0 ]] && command -v duf >/dev/null 2>&1; then
	echo 'duf already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install duf

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armv7
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o ${TMPDIR}/duf.deb -L "https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${ARCH}.deb"
		sudo dpkg -i ${TMPDIR}/duf.deb

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install duf
	fi
fi
