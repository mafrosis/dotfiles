#! /bin/zsh -e

source ./lib.sh
info '## Setup ssh'

# Create a new SSH key for Github in dotfiles, before stow symlinks into $HOME
if [[ ! -f $HOME/dotfiles/ssh/.ssh/github.pky ]]; then
	ssh-keygen -t rsa -b 4096 -f "$HOME/dotfiles/ssh/.ssh/github.pky" -N ''

	echo 'New Github key created; add this public part at https://github.com/settings/keys'
	echo ''
	cat "$HOME/dotfiles/ssh/.ssh/github.pky.pub"
	echo ''
fi

# On macOS, use openssh latest
if [[ $(uname) == 'Darwin' ]]; then
	brew install openssh

	sudo ln -sf /opt/homebrew/bin/ssh-agent /usr/local/bin
fi
