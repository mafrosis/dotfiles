#! /bin/bash -e

SALT_VERSION=${SALT_VERSION:-v3001}

# install salt package
if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
		exit 3
	fi
	brew install saltstack

elif [[ $(uname) == 'Linux' ]]; then
	if command -v salt-call >/dev/null 2>&1; then
		echo 'Salt already installed!'
	else
		# install salt-minion via bootstrap
		sudo -v
		curl -L http://bootstrap.saltstack.org | sudo sh -s -- -x python3 git "${SALT_VERSION}"
	fi
fi

# configure the salt-minion
if [[ ! -d /etc/salt ]]; then
	sudo mkdir /etc/salt
fi

sudo mkdir -p /etc/salt
sudo tee /etc/salt/minion > /dev/null <<EOF
file_client: local
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

# stop and disable the minion service
sudo systemctl stop salt-minion
sudo systemctl disable salt-minion

# skip stow in top-level install.sh
exit 255
