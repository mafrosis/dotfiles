#! /bin/bash

# Bootstrap Vagrant & VMware on this machine

# install missing Homebrew
if [[ $(uname) == 'Darwin' ]]; then
	if ! command -v brew >/dev/null 2>&1; then
		./osx/homebrew.sh --init
	fi
fi

# install VMware Fusion and Vagrant
brew cask install vagrant vmware-fusion

# open VMWare on first run; block until it's closed
if [[ ! -f /Library/Preferences/VMware\ Fusion/networking ]]; then
	echo 'You must now authorise VMWare Fusion.. Script will continue when VMWare is closed'
	open -W /Applications/VMware\ Fusion.app
fi

# setup Vagrant VMware plugin
if ! vagrant plugin list | grep -q vagrant-vmware-fusion; then
	vagrant plugin install vagrant-vmware-fusion

	# install Vagrant VMware license
	if [[ -f ~/Google\ Drive/license.lic ]]; then
		vagrant plugin license vagrant-vmware-fusion ~/Google\ Drive/license.lic
	else
		echo 'Vagrant VMWare license not found at ~/Google Drive/license.lic'
	fi
fi

# setup VMWare networking
if pgrep -f vmware-vmx; then
	echo 'You must stop VMWare Fusion before running this script again'
else
	# stop VMWare networking and recreate base config
	sudo vmnet-cli --stop
	sudo rm -rf /Library/Preferences/VMware\ Fusion/networking* /Library/Preferences/VMware\ Fusion/vmnet*
	sudo vmnet-cli --configure

	# configure VMWare vmnet devices to nice IP ranges
	for N in 1 8; do
		sudo sed -i '' -e "s/.*VNET_${N}_HOSTONLY_SUBNET.*/answer VNET_${N}_HOSTONLY_SUBNET 172.16.${N}.0/" /Library/Preferences/VMware\ Fusion/networking
	done
fi

# also install Packer
brew install packer
