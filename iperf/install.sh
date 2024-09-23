#! /bin/zsh

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

if ! command -v iperf3 >/dev/null 2>&1; then
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
			exit 3
		fi
		brew install iperf3

	elif [[ -n $TERMUX_VERSION ]]; then
		pkg install -y iperf3

	elif [[ $(uname) == 'Linux' ]]; then
		sudo apt-get install -y iperf3
	fi
fi

