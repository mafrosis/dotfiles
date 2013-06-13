#! /bin/bash

umount /dev/mapper/enc

if [ -d /var/host/media/removable/luks ]; then
	rm -r /var/host/media/removable/luks
fi

sudo cryptsetup luksClose enc
