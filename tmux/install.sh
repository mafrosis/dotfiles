#! /bin/zsh -e

source ./lib.sh
info '## Setup tmux'

# install tmux package
if ! command -v tmux >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		brew install tmux

	elif [[ -n $TERMUX_VERSION ]]; then
		pkg install -y tmux

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $(id -u) -gt 0 ]]; then
			sudo apt-get install -y tmux
		else
			apt-get install -y tmux
		fi
	fi
fi

# symlink all custom themes into tmux-powerline source
for F in tmux/powerline-themes/*; do
	echo "Installing powerline theme $F"
	ln -sf "$HOME/dotfiles/$F" "tmux/tmux-powerline/themes/"
done

# symlink all custom segments into tmux-powerline source
for F in tmux/powerline-segments/*; do
	echo "Installing powerline segment $F"
	ln -sf "$HOME/dotfiles/$F" "tmux/tmux-powerline/segments/"
done

THEME=generic

# if this host has a custom theme, switch to it
if [[ -f "tmux/powerline-themes/$(hostname).sh" ]]; then
	echo "Switching to theme $(hostname).sh"
	THEME="$(hostname)"
fi

tee "$HOME/.tmux-powerlinerc" > /dev/null <<EOF
export TMUX_POWERLINE_DEBUG_MODE_ENABLED=false
export TMUX_POWERLINE_PATCHED_FONT_IN_USE=true
export TMUX_POWERLINE_THEME=${THEME}
EOF
