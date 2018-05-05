#! /bin/bash

# rtorrent passes d.get_custom1 in $1 and d.get_base_path in $2

USAGE='move-torrent.sh [-h] label [download_path]'

while getopts 'h' options
do
	case $options in
		h ) echo "$USAGE" && exit 1;;
	esac
done
shift $((OPTIND-1))

# label arrives urlencoded from rtorrent
LABEL=$(python -c "import urllib; print urllib.unquote('$1')")
SOURCE_PATH=$2

if [[ $# -lt 1 ]]; then
	echo "$USAGE"
	exit 1
fi

if [[ -z $LABEL ]]; then
	echo 'No tag specified'
	exit 1
fi

# /home/rtorrent/bin/move-torrent.sh
#NAME=$(find . -name "Formula.1.2017x0*" -type d | sort -r | head -1)

#rsync -avPh -n /media/download/rtorrent/ --include="${NAME}" --exclude='*' /media/pools/video/F1

# set custom destination paths for some special labels
if [[ $LABEL == 'movie' ]]; then
	DEST='/media/pools/movies'
elif [[ $LABEL == 'music' ]]; then
	DEST='/media/pools/music/mp3/DJ'
else
	DEST="/media/pools/video/$LABEL"
fi

# copy the download to its destination
rsync -avhP "$SOURCE_PATH" "$DEST"

if [[ $? -eq 0 ]]; then
	echo "$SOURCE_PATH :: $DEST" >> /var/log/move-torrent.log
else
	echo "$SOURCE_PATH :: FAILED TO COPY ($?)" >> /var/log/move-torrent.log
fi

# set permissions on the destination folder
find "$DEST" -type d -exec sudo chown mafro:video {} \;
