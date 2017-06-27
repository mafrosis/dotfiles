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
		$SUDO apt-get install -y python-dev python-pip
	fi

fi


for PIP in pip pip3;
do
	# update pip itself
	$PIP install -U pip setuptools

	# install a couple things via pip
	$PIP install \
		bs4 \
		ipdb \
		pyflakes \
		requests
done

# only install virtualenv for python2
pip install virtualenv
