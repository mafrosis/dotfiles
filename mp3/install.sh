#! /bin/zsh -e

source ./lib.sh
info '## Setup mp3'

if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew'
		exit 3
	fi
fi

requires=(lame flac opus-tools ncmpcpp mplayer)

for app in $requires; do
	if ! command -v ${app} >/dev/null 2>&1; then
		info "## Installing ${app}"

		if [[ -n $TERMUX_VERSION ]]; then
			pkg install -y ${app}

		elif [[ $(uname) == 'Darwin' ]]; then
			brew install ${app}

		elif [[ $(uname) == 'Linux' ]]; then
			sudo apt-get install -y ${app}
		fi
	fi
done

info '## Installing eyeD3 globally'
if ! command -v uv >/dev/null 2>&1; then
	error "Python needs to be installed for eyeD3"
else
	uv tool install --force eyeD3
fi
