#! /bin/bash

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo'
else
	SUDO=''
fi

if ! command -v pip >/dev/null 2>&1; then

	# install pip package
	if [[ $(uname) == 'Darwin' ]]; then
		if ! command -v brew >/dev/null 2>&1; then
			echo 'Run ./install.sh osx first to bootstrap OSX with Homebrew & Python'
			exit 3
		fi

	elif [[ $(uname) == 'Linux' ]]; then
		$SUDO apt-get install -y python-dev python-pip python-virtualenv
	fi

fi


# update pip itself
pip install -U pip setuptools

# install a couple things via pip
pip install \
	ipdb \
	pyflakes
