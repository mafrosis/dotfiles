#! /bin/bash

# Bootstrap Vagrant & VMware on this machine

# install missing Homebrew
if [[ $(uname) == 'Darwin' ]] && [[ -z $(which brew) || -z $(brew cask &>/dev/null) ]] ; then
	./osx/homebrew.sh --init
fi

# install VMware Fusion and Vagrant
brew cask install vagrant vmware-fusion6

# setup Vagrant VMware plugin
vagrant plugin install vagrant-vmware-fusion

# install Vagrant VMware license
if [[ -f ~/Desktop/license.lic ]]; then
	vagrant plugin license vagrant-vmware-fusion license.lic
else
	echo 'Vagrant VMWare license not found at ~/Desktop/license.lic'
fi

# also install Packer
if [[ -z $(brew tap | grep homebrew/binary) ]]; then
	brew tap homebrew/binary
fi
brew install packer
