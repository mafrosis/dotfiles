#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# passed from /dotfiles/install.sh
FORCE=${1:-0}

# install salt package
if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
		exit 3
	fi
	brew install saltstack

elif [[ $(uname) == 'Linux' ]]; then
	if [[ $FORCE -eq 0 ]] && command -v salt-call >/dev/null 2>&1; then
		echo 'Salt already installed!'
	else
		if [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		elif [[ $(uname -m) = armv7l ]]; then
			ARCH=armhf
		else
			ARCH=amd64
		fi

		# source $VERSION_ID and $VERSION_CODENAME
		source /etc/os-release

		# install salt-minion via apt
		sudo curl -fsSL -o /etc/apt/keyrings/salt-archive-keyring-2023.gpg \
			https://repo.saltproject.io/salt/py3/debian/${VERSION_ID}/${ARCH}/SALT-PROJECT-GPG-PUBKEY-2023.gpg
		echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=${ARCH}] https://repo.saltproject.io/salt/py3/debian/${VERSION_ID}/${ARCH}/latest ${VERSION_CODENAME} main" | sudo tee /etc/apt/sources.list.d/salt.list
		sudo apt update
		sudo apt install salt-minion
	fi
fi

# configure the salt-minion
if [[ ! -d /etc/salt ]]; then
	sudo mkdir /etc/salt
fi

sudo mkdir -p /etc/salt
sudo tee /etc/salt/minion > /dev/null <<EOF
master: locke
state_output: mixed
log_level: info
id: $(hostname -s)
file_roots:
  base:
    - $HOME/dotfiles/salt
pillar_roots:
  base:
    - $HOME/dotfiles/salt/pillar
EOF

# print the install salt version
salt-call --version

# skip stow in top-level install.sh
exit 255
