#! /bin/bash

if [[ $(uname) == 'Darwin' ]]; then
	# I don't use tmux on OSX
	return
fi

if ! command -v tmux >/dev/null 2>&1; then

	# install tmux package
	if [[ $(uname) == 'Linux' ]]; then
		sudo aptitude install tmux
	fi

fi

# install tmux-powerline from git
git clone https://github.com/mafrosis/tmux-powerline.git "$HOME/tmux-powerline"
