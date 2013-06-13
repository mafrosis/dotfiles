#! /bin/bash

sudo cryptsetup luksOpen /dev/mmcblk1p1 enc

if [ ! -d /var/host/media/removable/luks ]; then
	mkdir /var/host/media/removable/luks
fi

sudo chown mafro:mafro /var/host/media/removable/luks

mount /dev/mapper/enc /var/host/media/removable/luks
