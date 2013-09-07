#! /bin/bash

usage="Usage: ./install.sh [-f force] app1 [app2 app3 ..]"

FORCE=0
while getopts "f" options
do
	case $options in
		f ) FORCE=1;;
		* ) echo $usage
			exit 1;;
	esac
done
shift $((OPTIND-1))

# TODO verify execution is one dir down from $HOME
# ie, $HOME/dotfiles/install.sh

PWD=$(pwd)

for app in "$@"
do
	# if -f is supplied forcibly overwrite existing files
	if [ $FORCE -eq 1 ]; then
		IFS=$(echo -en "\n\b")

		# check stow version
		VERSION=$(stow -V | awk '/stow/ {print $5}')
		if [ ${VERSION:0:1} -eq 1 ]
		then
			# v.1.3.3
			# parse stow's conficts
			CONFLICTS=$(stow -c $app 2>&1 | awk '/CONFLICT/ {print $4}')
			for filename in $CONFLICTS; do
				if [ -f $filename ]; then
					echo "Deleting symlink $filename"
					rm -f "$filename"
				fi
			done
		else
			# v2.2.0
			# remove existing symlinks
			CONFLICTS=$(stow -nv --stow $app 2>&1 | awk '/not owned by stow/ {print $9}')
			for filename in $CONFLICTS; do
				if [ -L "$HOME/$filename" ]; then
					echo "Deleting symlink $HOME/$filename"
					rm -f "$HOME/$filename"
				fi
			done

			# remove files which would be replaced with symlinks
			CONFLICTS=$(stow -nv --stow $app 2>&1 | awk '/neither a link nor a directory/ {print $11}')
			for filename in $CONFLICTS; do
				if [ -f "$HOME/$filename" ]; then
					echo "Deleting file $HOME/$filename"
					rm -f "$HOME/$filename"
				fi
			done
		fi
	fi

	# use stow to create symlinks in $HOME
	stow -v --restow $app

	# special behaviour for vim and vundle
	if [ "$app" == "vim" ]; then
		git submodule update --init
		vim +BundleInstall +qall
	fi
done
