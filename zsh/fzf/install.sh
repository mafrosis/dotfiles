#! /bin/bash -e

echo 'Installing fzf..'

FZF_VERSION=${FZF_VERSION:-0.27.2}

# Install fzf package
if ! command -v fzf >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(uname -m) =~ arm(.*) ]]; then
			ARCH=armv7
		elif [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi
		curl -o /tmp/fzf.tgz -L "https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${ARCH}.tar.gz"
		tar xzf /tmp/fzf.tgz -C /tmp
		sudo mv /tmp/fzf /usr/local/bin

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install fzf
	fi
fi
