#! /bin/bash

# rtorrent d.get_custom1 in $1
# rtorrent d.get_base_path in $2

usage="move-torrent.sh [-h] tag download_path"

while getopts "h" options
do
	case $options in
		h ) echo $usage
			exit 1;;
		\? ) echo $usage
			 exit 1;;
		* ) echo $usage
			exit 1;;
	esac
done
shift $((OPTIND-1))

if [ $# -ne 2 ]; then
	echo $usage
	exit 1
fi

# verify download_path is valid
if [ ! -d "$2" ] && [ ! -f "$2" ]; then
	echo "Download target is neither file or directory"
	exit 2
fi

if [ "$1" == "movie" ]; then
	DEST="Movies/HD-1080p"
else
	DEST=$1
fi

rsync -avP "$2" "/media/pools/video/$DEST/"
find "/media/pools/video/$DEST" -type d -exec sudo chown mafro:video {} \;
echo "$2 :: /media/pools/video/$DEST/" >> /var/log/move-torrent.log
