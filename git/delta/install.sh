#! /bin/zsh

source ./lib.sh
info '## Setup git-delta'

DELTA_VERSION=${DELTA_VERSION:-0.15.1}
TMPDIR=${TMPDIR:-/tmp}

# install git-delta
if [[ $FORCE -eq 0 ]] && command -v delta >/dev/null 2>&1; then
	echo 'git-delta already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install -y git-delta

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) = x86_64 ]]; then
			# Special case for Linux on x86
			# https://github.com/dandavison/delta/issues/504#issuecomment-805392519
			curl -o ${TMPDIR}/git-delta.tgz -L https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/delta-${DELTA_VERSION}-x86_64-unknown-linux-musl.tar.gz
			tar xzf ${TMPDIR}/git-delta.tgz -C ${TMPDIR} --strip-components=1
			sudo mv ${TMPDIR}/delta /usr/local/bin

		else
			if [[ $(uname -m) =~ arm(.*) ]]; then
				ARCH=armhf
			elif [[ $(uname -m) = aarch64 ]]; then
				ARCH=arm64
			else
				ARCH=amd64
			fi
			curl -o ${TMPDIR}/git-delta.deb -L https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCH}.deb
			sudo dpkg -i ${TMPDIR}/git-delta.deb
		fi

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install git-delta
	fi
fi
