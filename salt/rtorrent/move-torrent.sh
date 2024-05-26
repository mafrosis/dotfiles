#! /bin/bash

# method.set_key = event.download.finished,check_complete,"execute=move-torrent.sh,$d.base_path=,$d.custom1="

USAGE='move-torrent.sh [-h] download_path [label]'

while getopts 'h' options
do
	case $options in
		h ) echo "$USAGE" && exit 1;;
		* ) echo "$USAGE" && exit 1;;
	esac
done
shift $((OPTIND-1))

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

SOURCE_PATH=$1
LABEL=$(urldecode "$2")

if (( $# == 0 || $# > 2 )); then
	echo "$USAGE"
	exit 1
fi

# verify download_path is valid
if [[ ! -d $SOURCE_PATH && ! -f $SOURCE_PATH ]]; then
	echo 'Download target is neither file or directory'
	exit 2
fi

if [[ $SOURCE_PATH =~ Formula\.1\.20 ]]; then
	LABEL=F1
fi

printf "%s\\t%s\\t%s\\n" "$(date)" "$SOURCE_PATH" "$LABEL" >> /var/log/move-torrent.log

# set custom destination paths for some special labels
if [[ $LABEL == 'movie' ]]; then
	DEST='/media/pool/movies'
	rsync -avhP "$SOURCE_PATH" "$DEST"

elif [[ $LABEL == 'music' ]]; then
	DEST='/media/zpool/music/mp3/DJ'
	rsync -avhP "$SOURCE_PATH" "$DEST"

elif [[ $LABEL == 'F1' ]]; then
	DEST='/media/zpool/tv/video/F1'
	rsync -avhP --exclude "03.Post*mp4" --exclude "01.Pre*mp4" "$SOURCE_PATH" "$DEST"

	sleep 2

	# Send HUP to MQTT F1 listing app
	docker kill --signal=SIGHUP "$(docker ps | grep recentf1 | cut -d\  -f 1)"

	# Clean up irrelevant files
	find /media/zpool/tv/video/F1 \( -name "03.Post*mp4" -or -name "01.Pre*mp4" \) -delete
else
	exit 44
fi

# set permissions on the destination folder
find "$DEST" -type d -exec sudo chown mafro:video {} \;
