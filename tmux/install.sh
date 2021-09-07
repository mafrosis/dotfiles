#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if [[ $(uname) == 'Darwin' ]]; then
	# I don't use tmux on OSX
	return
fi

# install tmux package
if ! command -v tmux >/dev/null 2>&1; then
	if [[ $(uname) == 'Linux' ]]; then
		if [[ $(id -u) -gt 0 ]]; then
			sudo apt-get install -y tmux
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

tee tmux/.tmux-powerlinerc > /dev/null <<EOF
export TMUX_POWERLINE_DEBUG_MODE_ENABLED=false
export TMUX_POWERLINE_PATCHED_FONT_IN_USE=true
export TMUX_POWERLINE_THEME=generic
EOF

# if this host has a custom theme, switch to it
if [[ -f "tmux/powerline-themes/$(hostname).sh" ]]; then
	echo "Switching to theme $(hostname).sh"
	sed -i "s/THEME=generic/THEME=$(hostname)/g" tmux/.tmux-powerlinerc
fi

# symlink all custom segments into tmux-powerline source
for F in tmux/powerline-segments/*; do
	echo "Installing powerline segment $F"
	ln -sf "$HOME/dotfiles/$F" "$HOME/tmux-powerline/segments/"
done
