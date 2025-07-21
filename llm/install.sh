#! /bin/zsh

source ./lib.sh
info '## Setup llm.datasette.io'

# https://llm.datasette.io
uv tool install llm

# Add openrouter
if ! llm plugins | grep -q llm-openrouter; then
	llm install llm-openrouter
fi
if [[ -n $OPENROUTER_KEY ]]; then
	llm keys set openrouter --value $OPENROUTER_API_KEY
	echo "$(llm models list | grep openrouter | wc -l) models available"
else
	warn 'Missing $OPENROUTER_KEY, not configured for LLM'
fi

# Add ollama
if ! llm plugins | grep -q llm-ollama; then
	brew install ollama
	# curl -fsSL https://ollama.com/install.sh | sh
	llm install llm-ollama
fi

# More plugins
if ! llm plugins | grep -q llm-jq; then
	llm install llm-jq
fi
if ! llm plugins | grep -q llm-cmd; then
	llm install llm-cmd
fi

echo 'Plugins:'
llm plugins | grep name

info '## Setup goose'

if [[ $(uname) == 'Darwin' ]]; then
	brew install block-goose-cli
else
	echo 'Goose on linux not supported by install.sh'
fi
