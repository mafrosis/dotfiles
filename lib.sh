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
