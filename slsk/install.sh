#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# bail if not Darwin
if [[ $(uname) == 'Darwin' ]] ; then
	brew install soulseek
fi

exit 255
