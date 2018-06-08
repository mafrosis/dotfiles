#! /bin/bash

# Script sets up python3 for normal operations
# and assumes python2 is system-python and thus needs sudo

if [[ $(id -u) -gt 0 ]]; then
	SUDO='sudo'
else
	SUDO=''
fi

if ! command -v pip >/dev/null 2>&1; then

	# install pip package
	if [[ $(uname) == 'Darwin' ]]; then
		curl https://bootstrap.pypa.io/get-pip.py | sudo -H python

	elif [[ $(uname) == 'Linux' ]]; then
		$SUDO apt-get install -y python-dev python-pip python3-dev python3-pip
	fi

fi


# update pip itself
pip3 install -U pip setuptools

# install a couple things via pip
pip3 install \
	bs4 \
	ipdb \
	pyflakes \
	requests

# only install virtualenv for python2
sudo -H pip install virtualenv
