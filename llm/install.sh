#! /bin/zsh

# https://llm.datasette.io
uv tool install llm

# Add openrouter
llm install llm-openrouter
llm keys set openrouter --value $OPENROUTER_API_KEY
echo "$(llm models list | grep openrouter | wc -l) models available"

# Add ollama
llm install llm-ollama

# More plugins
llm install llm-jq
