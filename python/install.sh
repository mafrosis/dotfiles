#! /bin/bash

# Ensure both python2+pip and python3+pip is available
# Assume python2 installed by system and thus needs sudo

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo -H'
else
	SUDO=''
fi

if ! command -v pip2 >/dev/null 2>&1; then
	# install pip package
	curl https://bootstrap.pypa.io/get-pip.py | $SUDO python2
fi

if ! command -v python3 >/dev/null 2>&1; then
	# install python3
	if [[ $(uname) == 'Darwin' ]]; then
		brew install python

	elif [[ $(uname) == 'Linux' ]]; then
		$SUDO apt-get install -y python3 python3-dev
	fi
fi

# install distutils on ubuntu bionic
if [[ $(lsb_release -cs) == 'bionic' ]]; then
	$SUDO apt-get install -y python3-distutils
fi

if ! command -v pip3 >/dev/null 2>&1; then
	# install pip package
	curl https://bootstrap.pypa.io/get-pip.py | $SUDO python3
fi


# update pip itself
$SUDO pip3 install -U pip setuptools

# install a couple things via pip
$SUDO pip3 install \
	bs4 \
	eyeD3 \
	ipdb \
	pyflakes \
	requests

# only install virtualenv for python2
$SUDO pip install virtualenv
