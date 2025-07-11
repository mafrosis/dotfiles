#! /bin/zsh -e

source ./lib.sh
info '## Setup atuin'

ATUIN_VERSION=${ATUIN_VERSION:-18.6.1}
TMPDIR=${TMPDIR:-/tmp}

# Install atuin package
if [[ $FORCE -eq 0 ]] && command -v atuin >/dev/null 2>&1; then
	echo 'atuin already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install -y atuin

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install atuin

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			# Use MUSL on arm under linux, these are rpis
			ARCH=aarch64
			CLIB=musl
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=aarch64
			CLIB=gnu
		else
			ARCH=x86_64
			CLIB=gnu
		fi
		curl -o ${TMPDIR}/atuin.tgz -L \
			https://github.com/atuinsh/atuin/releases/download/v${ATUIN_VERSION}/atuin-${ARCH}-unknown-linux-${CLIB}.tar.gz
		tar xzf ${TMPDIR}/atuin.tgz -C ${TMPDIR}
		sudo mv ${TMPDIR}/atuin*/atuin /usr/local/bin
	fi
fi
