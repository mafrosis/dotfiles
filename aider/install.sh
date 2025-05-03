#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if ! command -v uv >/dev/null 2>&1; then
	print 'uv missing! First install python'
fi

uv tool install --python 3.12 aider-chat@latest

# Install playright and chromium
$(uv tool dir)/aider-chat/bin/python -m pip install --upgrade --upgrade-strategy only-if-needed 'aider-chat[playwright]'
$(uv tool dir)/aider-chat/bin/python -m playwright install --with-deps chromium
