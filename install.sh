#! /bin/bash

if [ -z "$1" ]; then
	echo "Usage: ./install.sh application"
	exit 1
fi

function create_sym() {
	if [ -h "$2" ]; then
		# if symlink exists, replace it
		ln -fs "$1" "$2"

	elif [ -f "$2" ]; then
		# if a file exists, ask user
		echo "Do you want to delete the existing config file '$2'? [y/N]"
		read y
		if [ y == "y" ]; then
			# replace existing file
			ln -fs "$1" "$2"
		fi
	else
		# doesnt exist, so create
		ln -s "$1" "$2"
	fi
}

function create_dir() {
	# symlink all files in directory
	for ITEM in $(find "$1" -mindepth 1)
	do
		LN=${ITEM#*$1/}
		# create directory or symlink file
		if [ -d "$1/$LN" ]; then
			mkdir -p "$HOME/$LN"
		elif [ -f "$1/$LN" ]; then
			create_sym "$1/$LN" "$HOME/$LN"
		fi
	done
}

PWD=$(pwd)

if [ -d "$PWD/$1" ]; then
	# create a directory and all containing symlinks
	create_dir "$PWD/$1"

elif [ -f "$PWD/.$1" ]; then
	# create a symlink
	create_sym "$PWD/${SRC[$i]}" "$HOME/${DST[$i]}"
fi

# special behaviour for vim and vundle
if [ "$1" == "vim" ]; then
	git submodule update --init
	create_dir "$PWD/$1"
	vim +BundleInstall +qall
fi
