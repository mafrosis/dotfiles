#! /bin/bash -e

# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# bail if not Darwin
if [[ $(uname) != 'Darwin' ]] ; then
	exit 255
fi

if [[ $1 -eq 1 ]]; then RESTOW='--restow'; else RESTOW=''; fi
if [[ $2 -eq 1 ]]; then DRY_RUN='-n'; else DRY_RUN=''; fi


# create bin directory in $HOME before stow symlinks into it
if [[ ! -d $HOME/bin ]]; then
	mkdir "$HOME/bin"
fi

# use xcode CLI tools
sudo xcode-select -switch /Library/Developer/CommandLineTools

# retrieve the morgant/tools-osx submodule
git submodule update --init osx/tools-osx

# stow some handy scripts from morgant/tools-osx into ~/bin
# add more by symlinking them into dotfiles/osx/bin
cd "$HOME/dotfiles/osx" || exit 2
stow -v bin "$RESTOW" --target="$HOME/bin" "$DRY_RUN"


# install Homebrew and apps
./homebrew.sh

# install Moom via mas
if [[ ! -L $HOME/Library/Preferences/com.manytricks.Moom.plist ]]; then
	if [[ -f $HOME/Library/Preferences/com.manytricks.Moom.plist ]]; then
		rm -f "$HOME/Library/Preferences/com.manytricks.Moom.plist"
	fi
	mas install 419330170
	ln -s "$HOME/dotfiles/osx/moom/com.manytricks.Moom.plist" "$HOME/Library/Preferences/com.manytricks.Moom.plist"
	echo 'You will need to restart to load Moom prefs'
fi


if [[ ! -f $HOME/dotfiles/osx/.osx-set-defaults-done ]]; then
	# setup OSX defaults; sudo is required
	if sudo -v; then
		# shellcheck disable=SC1091
		source set-defaults.sh
		echo 'You will need to restart to make new macOS defaults take effect'
		touch "$HOME/dotfiles/osx/.osx-set-defaults-done"
	else
		echo 'Sudo failed, skipping OSX defaults'
	fi
fi


# install Pixelmator Pro via mas
mas install 1289583905

# install Monodraw via mas
mas install 920404675

# skip stow in top-level install.sh
exit 255
