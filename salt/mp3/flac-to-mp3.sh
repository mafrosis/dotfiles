#! /bin/bash

IFS="$(echo -en "\n\r")"

FAIL=0

for F in *.flac; do
	flac -d "$F"
	if [ $? -eq 1 ]; then
		FAIL=1
		exit 1
	fi
done

#if [ $FAIL -eq 1 ];

for F in *.wav; do
	lame -V0 "$F" "${F%.*}.mp3"
	if [ $? -eq 1 ]; then
		FAIL=1
		exit 1
	fi
done

# cleanup
rm -f *.wav

# remove source files?
echo "Do you want to delete the source FLACs in $(pwd)? [y/N]"
read y
if [ "$y" == "y" ]; then
	rm -f *.flac
fi

if [ -f Folder.jpg ]; then
	mv Folder.jpg folder.jpg
elif [ ! -f folder.jpg ]; then
	echo 'Album art not found.'
fi

# auto-tag?
echo 'Do you want run auto-tag now? [y/N]'
read y
if [ "$y" == 'y' ]; then
	eyeD3 --plugin autotag .
fi
