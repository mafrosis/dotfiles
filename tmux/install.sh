#! /bin/bash

if [[ $(uname) == 'Darwin' ]]; then
	# I don't use tmux on OSX
	return
fi

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo'
else
	SUDO=''
fi

if ! command -v tmux >/dev/null 2>&1; then

	# install tmux package
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(id -u) -gt 0 ]]; then
			$SUDO apt-get install -y tmux
		else
			apt-get install -y tmux
		fi
	fi

fi

# install tmux-powerline from git
if [[ ! -d $HOME/tmux-powerline ]]; then
	git clone https://github.com/mafrosis/tmux-powerline.git "$HOME/tmux-powerline"
fi

# install the tmux-powerline custom theme
ln -sf "$HOME/dotfiles/tmux/powerline-theme.sh" "$HOME/tmux-powerline/themes/"

# symlink all custom segments into tmux-powerline
for F in tmux/.tmux-segments/*; do
	ln -sf "$HOME/dotfiles/$F" "$HOME/tmux-powerline/segments/"
done
