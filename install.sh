#! /bin/bash

usage='Usage: ./install.sh [[-f force]] app1 [[app2 app3 ..]]'

FORCE=0
while getopts 'f' options
do
	case $options in
		f ) FORCE=1;;
		* ) echo $usage
			exit 1;;
	esac
done
shift $((OPTIND-1))


# initialise OSX with missing homebrew
if [[ $(uname) == 'Darwin' && -z $(which brew) ]] ; then
	./osx/install.sh
fi

if [[ -z $(which stow) ]]; then
	if [[ $(uname) == 'Darwin' ]]; then
		brew install stow
	else
		sudo aptitude install stow
	fi
fi

function delete_symlinks {
	for filename in $1; do
		if [[ -f $HOME/$filename || -L $HOME/$filename ]]; then
			echo "Deleting file $HOME/$filename"
			rm -f "$HOME/$filename"
		fi
	done
}

for app in "$@"
do
	if [[ $FORCE -eq 1 ]]; then
		# forcefully delete any conflicts in stow
		IFS=$(echo -en "\n\b")

		# check stow version
		VERSION=$(stow -V | awk '/stow/ {print $5}')
		if [[ ${VERSION:0:1} -eq 1 ]]; then
			# v.1.3.3
			# parse stow's conficts
			CONFLICTS=$(stow -c $app 2>&1 | awk '/CONFLICT/ {print $4}')
			delete_symlinks "$CONFLICTS"
		else
			# v2.2.0
			# remove existing symlinks
			# remove files which would be replaced with symlinks
			# remove symlinks which belong to other packages (which may cause trouble later but ho hum)
			CONFLICTS=$(stow -nv $app 2>&1 | awk '/\* existing target is/ {print $NF}')
			echo $CONFLICTS
			delete_symlinks "$CONFLICTS"
		fi
	fi

	# use per-app install.sh, or just symlink with stow
	if [[ -x $app/install.sh ]]; then
		./$app/install.sh
	fi

	# restow when force flag supplied
	if [[ $FORCE -eq 1 ]]; then RESTOW='--restow'; else RESTOW=''; fi

	# use stow to create symlinks in $HOME
	stow -v --ignore='install.sh' --ignore='.md$' $app $RESTOW --target=$HOME
done
