#! /bin/bash

usage="Usage: ./install.sh [-f force] app1 [app2 app3 ..]"

FORCE=0

while getopts "f" options
do
	case $options in
		f ) FORCE=1;;
		\? ) echo $usage
			 exit 1;;
		* ) echo $usage
			exit 1;;
	esac
done

function create_sym() {
	if [ -h "$2" ]; then
		# if symlink exists, replace it
		ln -fs "$1" "$2"

	elif [ -f "$2" ]; then
		if [ $FORCE -eq 1 ]; then
			# replace existing file
			ln -fs "$1" "$2"
		else
			# if a file exists, ask user
			echo "Do you want to delete the existing config file '$2'? [y/N]"
			read y
			if [ "$y" == "y" ]; then
				ln -fs "$1" "$2"
			fi
		fi
	else
		# doesnt exist, so create
		ln -s "$1" "$2"
	fi
}

function create_dir() {
	# Recurse from $1 creating symlinks to all files in $HOME
	# Any hidden dirs in $1 will be recursed creating BOTH dir
	# and symlinking their descendant children
	for ITEM in $(find "$1" -mindepth 1 -maxdepth 1 -name \.\*)
	do
		LN=${ITEM#*$1/}
		if [ -d "$1/$LN" ]; then
			# recurse directories symlinking everything below
			mkdir -p "$HOME/$LN"
			for ITEM2 in $(find "$1/$LN" -mindepth 1)
			do
				LN2=${ITEM2#*$LN/}
				if [ -d "$1/$LN/$LN2" ]; then
					mkdir -p "$HOME/$LN/$LN2"
				elif [ -f "$1/$LN/$LN2" ]; then
					# create symlinks
					create_sym "$1/$LN/$LN2" "$HOME/$LN/$LN2"
				fi
			done
		elif [ -f "$1/$LN" ]; then
			# create symlinks
			create_sym "$1/$LN" "$HOME/$LN"
		fi
	done
}

PWD=$(pwd)

for app in "$@"
do
	if [ -d "$PWD/$app" ]; then
		# create a directory and all containing symlinks
		create_dir "$PWD/$app"

	elif [ -f "$PWD/.$app" ]; then
		# create a symlink
		create_sym "$PWD/${SRC[$i]}" "$HOME/${DST[$i]}"
	fi

	# special behaviour for vim and vundle
	if [ "$app" == "vim" ]; then
		git submodule update --init
		create_dir "$PWD/$app"
		vim +BundleInstall +qall
	fi
done
