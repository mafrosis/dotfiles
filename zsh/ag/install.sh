#! /bin/bash -e

echo 'Installing ag..'

# Install ag package
if ! command -v ag >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y silversearcher-ag

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install the_silver_searcher
	fi
fi
