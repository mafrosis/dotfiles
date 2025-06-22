#! /bin/zsh -e

source ./lib.sh
info '## Setup aider'

if ! command -v uv >/dev/null 2>&1; then
	print 'uv missing! First install python'
fi

# Aider requires python 3.12, and an available pip
uv tool install --python 3.12 aider-chat@latest --with pip
