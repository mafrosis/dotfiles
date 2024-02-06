#! /bin/bash -e

echo 'Installing fd..'

# Install fd package
if command -v fd >/dev/null 2>&1; then
	echo 'fd already installed!'
else
	if [[ $(uname -a) =~ (.*)(Ubuntu|Debian)(.*) ]]; then
		sudo apt install fd-find

		# symlink to "fd"
		mkdir -p ~/.local/bin
		ln -sf "$(command -v fdfind)" ~/.local/bin/fd

	elif [[ $(uname) == 'Darwin' ]]; then
		brew install fd
	fi
fi
