#! /bin/zsh

source ./lib.sh

# https://opencode.ai/
info '## Install & configure opencode'

if [[ $(uname) == 'Darwin' ]]; then
	brew install opencode
else
	curl -fsSL https://opencode.ai/install | bash
fi
