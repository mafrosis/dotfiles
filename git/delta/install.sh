#! /bin/bash

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

DELTA_VERSION=${DELTA_VERSION:-0.15.1}

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# install git-delta
if [[ $FORCE -eq 0 ]] && command -v delta >/dev/null 2>&1; then
	echo 'git-delta already installed!'
else
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) = x86_64 ]]; then
			# Special case for Linux on x86
			# https://github.com/dandavison/delta/issues/504#issuecomment-805392519
			curl -o /tmp/git-delta.tgz -L https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl.tar.gz
			tar xzf /tmp/git-delta.tgz -C /tmp --strip-components=1
			sudo mv /tmp/delta /usr/local/bin

		else
			if [[ $(uname -m) =~ arm(.*) ]]; then
				ARCH=armhf
			elif [[ $(uname -m) = aarch64 ]]; then
				ARCH=arm64
			else
				ARCH=amd64
			fi
			curl -o /tmp/git-delta.deb -L https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb
			sudo dpkg -i /tmp/git-delta.deb
		fi

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install git-delta
	fi
fi
