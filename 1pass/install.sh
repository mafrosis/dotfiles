#! /bin/bash -e

VERSION=${VERSION:-v1.12.3}

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# passed from /dotfiles/install.sh
FORCE=${1:-0}

if [[ $FORCE -eq 0 ]] && command -v op >/dev/null 2>&1; then
	echo 'Already installed'
	exit 3
fi

# bail if Darwin, else specify machine arch
if [[ $(uname) == 'Darwin' ]]; then
	echo 'Use "install.sh osx" on macOS'
	exit 255

elif [[ $(uname -m) =~ arm(.*) ]]; then
	ARCH=arm
else
	ARCH=amd64
fi

curl -o /tmp/op.tgz -L "https://cache.agilebits.com/dist/1P/op/pkg/${VERSION}/op_linux_${ARCH}_${VERSION}.zip"

unzip -o /tmp/op.tgz -d /tmp
sudo mv /tmp/op /usr/local/bin

sudo apt-get install -y jq

read -rp "Enter 1password secret key: " SECRET_KEY
op signin https://my.1password.com services@mafro.net "$SECRET_KEY"
