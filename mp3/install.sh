#! /bin/zsh -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

function info {
	>&2 print "\e[32m$1\e[0m"
}
function error {
	>&2 print "\e[32m$1\e[0m"
}

if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
		exit 3
	fi
fi

requires=(lame flac opus-tools ncmpcpp mplayer)

for app in $requires; do
	if ! command -v lame >/dev/null 2>&1; then
		info "## Installing ${app}"

		if [[ -n TERMUX_VERSION ]]; then
			pkg install -y ${app}

		elif [[ $(uname) == 'Darwin' ]]; then
			brew install ${app}

		elif [[ $(uname) == 'Linux' ]]; then
			sudo apt-get install -y ${app}
		fi
	fi
done

info '## Installing eyeD3 globally'
if ! command -v pipx >/dev/null 2>&1; then
	error "Python needs to be installed for eyeD3"
else
	pipx install eyeD3
fi
