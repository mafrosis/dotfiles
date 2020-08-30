#! /bin/bash -e

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

# symlink all custom themes into tmux-powerline source
for F in tmux/powerline-themes/*; do
	echo "Installing powerline theme $F"
	ln -sf "$HOME/dotfiles/$F" "$HOME/tmux-powerline/themes/"
done

# symlink all custom segments into tmux-powerline source
for F in tmux/powerline-segments/*; do
	echo "Installing powerline segment $F"
	ln -sf "$HOME/dotfiles/$F" "$HOME/tmux-powerline/segments/"
done
