#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# bail if not Darwin
if [[ $(uname) != 'Darwin' ]] ; then
	exit 255
fi

brew install soulseek
