#! /bin/zsh -e

source ./lib.sh
info '## Setup fzf'

FZF_VERSION=${FZF_VERSION:-0.61.3}
TMPDIR=${TMPDIR:-/tmp}

# Install fzf package
if [[ $FORCE -eq 0 ]] && command -v fzf >/dev/null 2>&1; then
	echo 'fzf already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install -y fzf

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armv7
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o ${TMPDIR}/fzf.tgz -L \
			https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz
		tar xzf ${TMPDIR}/fzf.tgz -C ${TMPDIR}
		sudo mv ${TMPDIR}/fzf /usr/local/bin

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install fzf
	fi
fi
