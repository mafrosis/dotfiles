#! /bin/bash

# install missing Homebrew
if [[ $(uname) == 'Darwin' && -z $(which brew) ]] ; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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

# skip stow in top-level install.sh
exit 255
>>>>>>> cbd4244... fixup! ff0b6c2a59d59b3f973db6d7085faefbbe85d6dd
