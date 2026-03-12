# vim: set ft=bash:

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then
	set -x
fi

# Pretty logging functions
function info {
	>&2 printf "\e[36m%s\e[0m\n" "$1"
}
function error {
	>&2 printf "\e[31m%s\e[0m\n" "$1"
}
function warn {
	>&2 printf "\e[35m%s\e[0m\n" "$1"
}

# Wrap brew command, ensuring setup
function brew {
	if [[ ! -x /opt/homebrew/bin/brew ]] && [[ ! -x /usr/local/bin/brew ]]; then
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# Ensure brew is on PATH for this shell session
	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -x /usr/local/bin/brew ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi

	command brew "$@"
}
