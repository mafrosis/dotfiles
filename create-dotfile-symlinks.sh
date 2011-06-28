#! /bin/bash

SRC=(
	".asoundrc2"
	"bash"
	"git"
	".muttrc"
	"ncmpc/config"
	".rtorrent.rc"
	".tmux.conf"
	".screenrc"
	"vim"
);
DST=(
	".asoundrc2"
	""
	""
	".muttrc"
	"ncmpc/config"
	".rtorrent.rc"
	".tmux.conf"
	".screenrc"
	""
);

function create_sym() {
	if [ -h "$2" ]; then
		# if symlink exists, replace it
		ln -fs "$1" "$2"

	elif [ -f "$2" ]; then
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


PWD=$(pwd)

for ((i=0; i<${#SRC[@]}; i++)); do
	if [ -f "$PWD/${SRC[$i]}" ]; then
		# create a symlink
		create_sym "$PWD/${SRC[$i]}" "$HOME/${DST[$i]}"
	
	elif [ -d "$PWD/${SRC[$i]}" ]; then
		# list all dirs/files below this location
		for ITEM in $(find "${SRC[$i]}" -mindepth 1 -printf "%P\n")
		do
			# create directory or symlink file
			if [ -d "$PWD/${SRC[$i]}/$ITEM" ]; then
				mkdir -p "$HOME/$ITEM"
			elif [ -f "$PWD/${SRC[$i]}/$ITEM" ]; then
				create_sym "$PWD/${SRC[$i]}/$ITEM" "$HOME/$ITEM"
			fi
		done
	fi
done


