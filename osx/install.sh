#! /bin/bash

# bail if not Darwin
if [[ $(uname) != 'Darwin' ]] ; then
	exit 255
fi

if [[ $1 -eq 1 ]]; then RESTOW='--restow'; else RESTOW=''; fi
if [[ $2 -eq 1 ]]; then DRY_RUN='-n'; else DRY_RUN=''; fi


# setup OSX defaults; sudo is required
sudo -v
if [[ $? -eq 0 ]]; then
	$HOME/dotfiles/osx/set-defaults.sh
	echo 'You will probably need to restart OSX to make new settings take effect'
else
	echo 'Sudo failed, skipping OSX defaults'
fi


# create bin directory in $HOME before stow symlinks into it
if [[ ! -d $HOME/bin ]]; then
	mkdir $HOME/bin
fi

# retrieve the morgant/tools-osx submodule
git submodule update --init osx/tools-osx

# stow some handy scripts from morgant/tools-osx into ~/bin
# add more by symlinking them into dotfiles/osx/bin
cd $HOME/dotfiles/osx
stow -v bin $RESTOW --target=$HOME/bin $DRY_RUN


# install Homebrew and apps
source ./homebrew.sh

if [[ $? -eq 0 ]]; then
	# install a couple things via pip, after Homebrew installs python
	sudo -H pip install -U pip virtualenvwrapper ipdb pyflakes
fi


# skip stow in top-level install.sh
exit 255
