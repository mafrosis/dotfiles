#! /bin/zsh -e

source ./lib.sh
info '## Setup python'

if [[ -n $TERMUX_VERSION ]]; then
	pkg install -y python3 uv

elif [[ $(uname) == 'Darwin' ]]; then
	# On macos, need to replace system python with Homebrew
	if python3 --help | grep /Library/Developer/CommandLineTools; then
		info '## Installing python3 & pipx'
		brew install python3
	fi
	if ! command -v uv >/dev/null 2>&1; then
		brew install uv
	fi

elif [[ $(uname) == 'Linux' ]]; then
	# Install python3 package if missing
	if ! command -v python3 >/dev/null 2>&1; then
		info '## Installing python3 & pipx'
		sudo apt-get install -y python3 python3-dev
	fi
	if ! command -v uv >/dev/null 2>&1; then
		curl -LsSf https://astral.sh/uv/install.sh | sh
	fi
fi

# On macOS, ensure python symlink points to Homebrew
if [[ $(uname) == Darwin ]] && [[ ! $(readlink $(which python)) =~ ^$HOMEBREW_PREFIX/(.*) ]]; then
	info '## Symlinking python3'
	sudo ln -sf $(which python3) /usr/local/bin/python
fi

info '## Install hatch'
uv tool install --upgrade hatch

info '## Install ruff'
uv tool install --upgrade ruff
