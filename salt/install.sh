#! /bin/zsh -e

source ./lib.sh
info '## Setup salt-minion'

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

	elif [[ $(uname -m) = armv7l ]]; then
		curl -L -o /tmp/bootstrap-salt.sh https://raw.githubusercontent.com/saltstack/salt-bootstrap/refs/heads/develop/bootstrap-salt.sh
		chmod +x /tmp/bootstrap-salt.sh
		sudo /tmp/bootstrap-salt.sh stable 3007.3

	else
		if [[ $(uname -m) = aarch64 ]]; then
			ARCH=arm64
		else
			ARCH=amd64
		fi

		# source $VERSION_ID and $VERSION_CODENAME
		source /etc/os-release

		# install salt-minion via apt
		curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
		curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources
		rm -f /etc/apt/sources.list.d/salt.list
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
