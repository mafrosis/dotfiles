#! /bin/bash

# Bootstrap Vagrant & VMware on this machine

# install missing Homebrew
if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		./osx/homebrew.sh --init
	fi
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

# configure VMWare vmnet devices to nice IP ranges
for N in 1 8; do
	sudo sed -i '' -e "s/.*VNET_${N}_HOSTONLY_SUBNET.*/answer VNET_${N}_HOSTONLY_SUBNET 172.16.${N}.0/" /Library/Preferences/VMware\ Fusion/networking
done

# also install Packer
if [[ -z $(brew tap | grep homebrew/binary) ]]; then
	brew tap homebrew/binary
fi
brew install packer
