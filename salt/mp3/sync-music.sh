#! /bin/bash -e

NAS_HOSTNAME=${NAS_HOSTNAME:-jorg}
NAS_USERNAME=${NAS_USERNAME:-mafro}
MPD_HOSTNAME=${MPD_HOSTNAME:-kvothe}
MPD_USERNAME=${MPD_USERNAME:-pi}

if command -v mpd &>/dev/null; then
	# mpd exists; script running on MPD host

	echo "Syncing from $NAS_USERNAME@$NAS_HOSTNAME"

	# pull music from NAS
	rsync -avP --delete "$NAS_HOSTNAME:/media/pools/music/mp3/" "$HOME/mp3"

	# set ownership on mpd directory
	sudo chown "$MPD_USERNAME:audio" -R "$HOME/mp3"

	# set permissions on mpd directory
	sudo find "$HOME/mp3" -type d -exec chmod 750 {} \;
	sudo find "$HOME/mp3" -type f -exec chmod 640 {} \;

else
	# mpd doesn't exist; script running on NAS

	# push music to MPD server
	echo 'Setting owner and mode on /media/pools/music'

	# set ownership on source
	sudo chown "$NAS_USERNAME:audio" -R /media/pools/music

	# set permissions on source
	sudo find /media/pools/music -type d -exec chmod 750 {} \;
	sudo find /media/pools/music -type f -exec chmod 640 {} \;

	echo "Syncing to $MPD_USERNAME@$MPD_HOSTNAME"

	# pull playlists from the MPD server
	rsync -avP "$MPD_HOSTNAME:/home/$MPD_USERNAME/playlists/" /media/pools/music/playlists

	# push music to the MPD server
	rsync -avP --delete /media/pools/music/mp3/ "$MPD_HOSTNAME:/home/$MPD_USERNAME/mp3"
fi
