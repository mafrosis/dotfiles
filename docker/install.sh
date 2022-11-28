#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if ! command -v docker >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install homebrew/cask/docker

	elif [[ $(uname) == 'Linux' ]]; then
		# add docker APT repo
		curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
		echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

		# install docker & compose
		sudo apt-get update && sudo apt-get install -y docker-ce docker-compose-plugin

		# add user to the docker group
		sudo usermod -aG docker $(whoami)
	fi
fi

# skip stow in top-level install.sh
exit 255
