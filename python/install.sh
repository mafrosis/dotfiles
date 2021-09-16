#! /bin/bash -e

# Never install python2
# If python2 is already installed, install pip for python2
# Always ensure python3+pip is installed

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# Assume nothing is installed
PYTHON2=0
PYTHON3=0
PYTHON2_PIP=0
PYTHON3_PIP=0

# Check python versions available
if command -v python2 >/dev/null 2>&1; then
	PYTHON2=1
	if command -v python2 -m pip -V >/dev/null 2>&1; then
		PYTHON2_PIP=1
	fi
fi

if command -v python3 >/dev/null 2>&1; then
	PYTHON3=1
	if command -v python3 -m pip -V >/dev/null 2>&1; then
		PYTHON3_PIP=1
	fi
fi

if command -v python >/dev/null 2>&1; then
	if [[ $(python -V 2>&1) =~ (.*)2\.(.*) ]]; then
		PYTHON2=1
		if command -v python -m pip -V >/dev/null 2>&1; then
			PYTHON2_PIP=1
		fi
	fi
	if [[ $(python -V 2>&1) =~ (.*)3\.(.*) ]]; then
		PYTHON3=1
		if command -v python -m pip -V >/dev/null 2>&1; then
			PYTHON3_PIP=1
		fi
	fi
fi

function print_installed() {
	[[ $1 -eq 1 ]] && echo "$2 is already installed" || echo "$2 is not installed"
}
print_installed $PYTHON2 'Python 2'
print_installed $PYTHON3 'Python 3'
print_installed $PYTHON2_PIP 'Pip for python 2'
print_installed $PYTHON3_PIP 'Pip for python 3'

if [[ $(uname) == 'Darwin' ]]; then
	if [ $PYTHON3 -eq 0 ]; then
		brew install python3
	fi

elif [[ $(uname) == 'Linux' ]]; then
	if [ $PYTHON3 -eq 0 ]; then
		sudo apt-get install -y python3 python3-dev
	fi
fi

if [ $PYTHON3_PIP -eq 0 ]; then
	curl -L https://bootstrap.pypa.io/get-pip.py | python3
fi

if [ $PYTHON2 -eq 1 ] && [ $PYTHON2_PIP -eq 0 ]; then
	curl -L https://bootstrap.pypa.io/pip/2.7/get-pip.py | python
	ln -s "$HOME/Library/Python/2.7/bin/pip2" /usr/local/bin
fi
echo 'Done'
