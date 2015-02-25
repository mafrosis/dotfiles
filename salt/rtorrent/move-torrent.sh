#! /bin/bash

# rtorrent passes d.get_custom1 in $1 and d.get_base_path in $2

USAGE='move-torrent.sh [-h] label download_path'

while getopts 'h' options
do
	case $options in
		h ) echo $USAGE && exit 1;;
	esac
done
shift $((OPTIND-1))

# label arrives urlencoded from rtorrent
LABEL=$(python -c "import urllib; print urllib.unquote('$1')")
SOURCE_PATH=$2

if [[ $# -ne 2 ]]; then
	echo $usage
	exit 1
fi

if [[ -z $LABEL ]]; then
	echo 'No tag specified'
	exit 1
fi

# verify download_path is valid
if [[ ! -d $SOURCE_PATH && ! -f $SOURCE_PATH ]]; then
	echo 'Download target is neither file or directory'
	exit 2
fi

# set custom destination paths for some special labels
if [[ $LABEL == 'movie' ]]; then
	DEST='/media/pools/video/Movies/HD-1080p'
elif [[ $LABEL == 'music' ]]; then
	DEST='/media/pools/music/mp3/DJ'
else
	DEST="/media/pools/video/$LABEL"
fi

# copy the download to its destination
rsync -avP "$SOURCE_PATH" "$DEST"

if [[ $? -eq 0 ]]; then
	echo "$SOURCE_PATH :: $DEST" >> /var/log/move-torrent.log
else
	echo "$SOURCE_PATH :: FAILED TO COPY ($?)" >> /var/log/move-torrent.log
fi

# set permissions on the destination folder
find "$DEST" -type d -exec sudo chown mafro:video {} \;
