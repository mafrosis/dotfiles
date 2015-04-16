#! /bin/bash

echo "Setting owner and mode on /media/pools/music"

# set ownership on source
sudo chown mafro:audio -R /media/pools/music

# set permissions on source
sudo find /media/pools/music -type d -exec chmod 750 {} \;
sudo find /media/pools/music -type f -exec chmod 640 {} \;

echo "Syncing to Kerplunk"

# pull playlists from kerplunk
rsync -avP --delete kerplunk:/home/mafro/playlists/ /media/pools/music/playlists

# push music to kerplunk
rsync -avP --delete /media/pools/music/mp3/ kerplunk:/home/mafro/mp3
