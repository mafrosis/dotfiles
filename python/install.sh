#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

function info {
	>&2 print "\e[32m$1\e[0m"
}

# Install python3 package if missing
if ! command -v python3 >/dev/null 2>&1; then
	info '## Installing python3'

	if [[ $(uname) == 'Darwin' ]]; then
		if [[ $PYTHON3 -eq 0 ]]; then
			brew install python3 pipx
			PYTHON3=1
		fi

	elif [[ $(uname) == 'Linux' ]]; then
		if [[ $PYTHON3 -eq 0 ]]; then
			sudo apt-get install -y python3 python3-dev pipx
			PYTHON3=1
		fi
	fi
fi

# Ensure python symlink is present
if ! command -v python >/dev/null 2>&1; then
	info '## Symlinking python3'
	sudo ln -sf $(which python3) /usr/local/bin/python
fi

info '## Ensuring & upgrading pip'
python -m ensurepip --upgrade

info '## Install hatch'
pipx install hatch

info '## fin'
