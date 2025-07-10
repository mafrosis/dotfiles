#! /bin/zsh -e

source ./lib.sh
info '## Setup kopia'

if ! command -v kopia >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		brew install kopia

	elif [[ $(uname) == 'Linux' ]]; then
		# add kopia APT repo
		curl -fsSL https://kopia.io/signing-key | sudo gpg --dearmor -o /etc/apt/keyrings/kopia-keyring.gpg
		echo "deb [signed-by=/etc/apt/keyrings/kopia-keyring.gpg] http://packages.kopia.io/apt/ stable main" | sudo tee /etc/apt/sources.list.d/kopia.list > /dev/null

		# install kopia
		sudo apt-get update && sudo apt-get install -y kopia
	fi
fi
