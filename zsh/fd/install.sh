#! /bin/zsh -e

source ./lib.sh
info '## Setup fd'

# Install fd package
if [[ $FORCE -eq 0 ]] && command -v fd >/dev/null 2>&1; then
	echo 'fd already installed!'
else
	if [[ -n $TERMUX_VERSION ]]; then
		pkg install fd

	elif [[ $(uname -a) =~ (.*)(Ubuntu|Debian)(.*) ]]; then
		sudo apt install fd-find

		# symlink to "fd"
		mkdir -p ~/.local/bin
		ln -sf "$(command -v fdfind)" ~/.local/bin/fd

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install fd
	fi
fi
