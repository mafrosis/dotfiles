#! /bin/zsh -e

source ./lib.sh
info '## Setup soulseek'

# bail if not Darwin
if [[ $(uname) == 'Darwin' ]] ; then
	brew install soulseek
fi

exit 255
