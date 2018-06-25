#! /bin/bash

# install salt package
if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
		exit 3
	fi
	brew install saltstack

	# configure just the salt-minion (no salt-master is setup)
	if [[ ! -d /etc/salt ]]; then
		sudo mkdir /etc/salt
	fi

	sudo touch /etc/salt/minion
	sudo tee /etc/salt/minion > /dev/null <<EOF
file_client: local
id: $(hostname -s)
file_roots:
  base:
    - $HOME/dotfiles/salt
    - $HOME/dotfiles/salt-formulae
pillar_roots:
  base:
    - $HOME/dotfiles/salt/pillar
EOF

	# print the install salt version
	salt-call --version

elif [[ $(uname) == 'Linux' ]]; then
	# install salt-minion via bootstrap
	curl -L http://bootstrap.saltstack.org | sudo sh -s -- git v2017.7.5
fi

# skip stow in top-level install.sh
exit 255
