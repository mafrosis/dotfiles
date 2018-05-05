#! /bin/bash

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
		curl -L http://bootstrap.saltstack.org | sudo sh -s -- git v2016.3.5
	fi
fi

# configure just the salt-minion (no salt-master is setup)
if [[ ! -d /etc/salt ]]; then
	sudo mkdir /etc/salt
fi

sudo touch /etc/salt/minion
sudo tee /etc/salt/minion > /dev/null <<EOF
file_client: local
state_output: mixed
#failhard: true
id: $(hostname -s)
file_roots:
  base:
    - $HOME/dotfiles/salt
    - $HOME/dotfiles/salt/salt-formulae
pillar_roots:
  base:
    - $HOME/dotfiles/salt/pillar
EOF

# print the install salt version
salt-call --version

# skip stow in top-level install.sh
exit 255
