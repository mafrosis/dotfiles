#! /bin/zsh -e

source ./lib.sh
info '## Setup osx'

# bail if not Darwin
if [[ $(uname) != 'Darwin' ]] ; then
	exit 255
fi

if [[ $FORCE -eq 1 ]]; then RESTOW='--restow'; else RESTOW=''; fi
if [[ $DRY_RUN -eq 1 ]]; then DRY_RUN='-n'; else DRY_RUN=''; fi


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

# skip stow in top-level install.sh
exit 255
