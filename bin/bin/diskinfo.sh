#! /bin/bash

USAGE='diskinfo.sh [-v] [-h] [device]

  -v	verbose printing
  -h	show this help'

# ensure run as root
if [[ $EUID -gt 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi


VERBOSE=0

while getopts 'vh' options
do
	case $options in
		v ) VERBOSE=1;;
		h ) echo "$USAGE" && exit 1;;
		* ) echo "$USAGE" && exit 1;;
	esac
done
shift $((OPTIND-1))


# install dependencies
if ! command -v smartctl &>/dev/null || ! command -v disktype &>/dev/null; then
	aptitude install smartmontools disktype
	if [[ $? -eq 1 ]]; then
		echo 'Unable to install smartctl and disktype'
		exit 2
	fi
fi

function query_disk {
	# extract hardware info from smartctl
	INFO="$(smartctl --info "$1")"
	MODEL="$(echo "$INFO" | grep 'Device Model' | cut -d' ' -f 3- | xargs)"
	SERIAL="$(echo "$INFO" | awk '/Serial Number/ {print $3}')"
	FIRMWARE="$(echo "$INFO" | awk '/Firmware/ {print $3}')"
	SIZE="$(echo "$INFO" | awk '/User Capacity/ {print substr($5,2) substr($6,1,length($6)-1)}')"

	# display disk header
	echo "========== $1 =========="
	echo -e "Model:\t\t$MODEL"
	if [[ $VERBOSE -eq 1 ]]; then
		echo -e "Serial:\t\t$SERIAL" | grep --color "$SERIAL"
	else
		echo -e "Serial\t\t$SERIAL"
	fi
	echo -e "Firmware:\t$FIRMWARE"
	echo -e "Size:\t\t$SIZE"

	if [[ $VERBOSE -eq 0 ]]; then
		echo '' && return
	fi

	# print partition info from disktype
	echo -e "\n---- Partitions ----------"
	disktype "$1" | awk 'NF && ! /^--/'

	# extra ZFS info
	if command -v zfs &>/dev/null; then
		# iterate zpools
		zpool list | awk '! /^NAME/ {print $1}' | while read POOL;
		do
			# display info if this disk in pool
			if zpool status "$POOL" | grep -q "$SERIAL"; then
				echo -e "\n---- ZFS Pools -----------"
				# display zpool info, highlighting this disk
				zpool status "$POOL" | \
					awk '/ONLINE/ && ! /state: ONLINE/ {print substr($0,2,length($0)-15)}' | \
					grep --color -E "^|$SERIAL"

				# display zpool mountpoints
				echo -e "\n---- ZFS Mountpoints -----"
				zfs list -d 1 barrel | awk '! /^NAME/ {print $0}'
			fi
		done
	fi

	# extra LVM info
	if command -v lvm &>/dev/null; then
		if [[ ! -z "$(pvdisplay 2>/dev/null | awk -v var="$1" '$0 ~ var')" ]]; then
			echo -e "\n---- LVM Volumes ---------"

			# iterate Volume Groups on this device
			pvdisplay "$1" | awk '/VG Name/ {print $3}' | while read VG_NAME;
			do
				# iterate Logical Volumes
				lvdisplay "$VG_NAME" | awk '/LV Path/ {print $3}' | while read LV_PATH;
				do 
					LV_NAME="$(lvdisplay "$LV_PATH" | awk '/LV Name/ {print $3}')"
					LV_SIZE="$(lvdisplay "$LV_PATH" | awk '/LV Size/ {print $3$4}')"
					MOUNTED="$(df | awk -v lv="$LV_NAME" '$0 ~ lv {print $6}')"
					echo -e "$LV_PATH\t$LV_SIZE\t\t$MOUNTED"
				done
			done
		fi
	fi

	echo ''
}

if [[ $# -eq 1 ]]; then
	if ! smartctl --scan | grep -q "$1"; then
		echo "Device $1 not found"
		exit 2
	fi
	# query disk passed as param
	query_disk "$1"
else
	# query all disks
	smartctl --scan | awk '{print $1}' | while read DEVICE;
	do
		query_disk "$DEVICE"
	done
fi
