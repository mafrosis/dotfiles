#! /bin/bash

USAGE='diskinfo.sh [-v] [-h] [device]

  -v	verbose printing
  -S	support SMART via USB
  -h	show this help'

# ensure run as root
if [[ $EUID -gt 0 ]]; then
	sudo "$0" "$@"
	exit $?
fi


VERBOSE=0
SMART_SAT=''

while getopts 'vSh' options
do
	case $options in
		v ) VERBOSE=1;;
		S ) SMART_SAT='-d sat';;
		h ) echo "$USAGE" && exit 1;;
		* ) echo "$USAGE" && exit 1;;
	esac
done
shift $((OPTIND-1))


# DEBUG mode controlled by env var
if [[ -n $DEBUG ]]; then set -x; fi

# install dependencies
if ! command -v smartctl &>/dev/null || ! command -v disktype &>/dev/null; then
	sudo apt install -y smartmontools disktype
	if [[ $? -eq 1 ]]; then
		echo 'Unable to install smartctl and disktype'
		exit 2
	fi
fi

function lookup_byid {
	if [[ -z $1 ]]; then
		return
	fi
	for D in /dev/disk/by-id/wwn-0x*; do
		DT="$(disktype "$D" | awk '/Disk GUID/ {print $3}')"
		if [[ $1 == "$DT" ]]; then
			echo "$D"
			break
		fi
	done
}

function query_disk {
	# extract hardware info from smartctl
	# shellcheck disable=SC2086
	INFO="$(smartctl $SMART_SAT --info "$1")"
	FAMILY="$(echo "$INFO" | grep 'Family' | cut -d' ' -f 3- | xargs)"
	MODEL="$(echo "$INFO" | grep 'Device Model' | cut -d' ' -f 3- | xargs)"
	SERIAL="$(echo "$INFO" | awk '/Serial Number/ {print $3}')"
	FIRMWARE="$(echo "$INFO" | awk '/Firmware/ {print $3}')"
	SIZE="$(echo "$INFO" | awk '/User Capacity/ {print substr($5,2) substr($6,1,length($6)-1)}')"
	MOUNT="$(lsblk "$1" | awk '{print "MOUNT="$NF}' | grep -i '/' | cut -f 2 -d = | head -1)"
	UUID="$(disktype "$1" | awk '/Disk GUID/ {print $3}')"
	WWN="$(lookup_byid "$UUID")"

	# display disk header
	echo "========================"
	echo -e "Family:\\t\\t$FAMILY"
	echo -e "Model:\\t\\t$MODEL"
	if [[ $VERBOSE -eq 1 ]]; then
		echo -e "Serial:\\t\\t$SERIAL" | grep --color "$SERIAL"
	else
		echo -e "Serial\\t\\t$SERIAL"
	fi
	echo -e "Firmware:\\t$FIRMWARE"
	echo -e "Size:\\t\\t$SIZE"
	if [[ -n $WWN ]]; then
		echo -e "Device:\\t\\t$1  $WWN"
	fi
	if [[ -n $MOUNT ]]; then
		echo -e "Mountpoint:\\t$MOUNT"
	fi

	if [[ $VERBOSE -eq 0 ]]; then
		echo '' && return
	fi

	# print partition info from disktype
	echo -e "\\n---- Partitions ----------"
	disktype "$1" | awk 'NF && ! /^--/'

	# extra ZFS info
	if command -v zfs &>/dev/null; then
		# iterate zpools
		zpool list | awk '! /^NAME/ {print $1}' | while read -r POOL;
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
		if [[ -n $(pvdisplay 2>/dev/null | awk -v var="$1" '$0 ~ var') ]]; then
			echo -e "\n---- LVM Volumes ---------"

			# iterate Volume Groups on this device
			pvdisplay "$1" | awk '/VG Name/ {print $3}' | while read -r VG_NAME;
			do
				# iterate Logical Volumes
				lvdisplay "$VG_NAME" | awk '/LV Path/ {print $3}' | while read -r LV_PATH;
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
	# shellcheck disable=SC2086
	if ! smartctl $SMART_SAT --scan | grep -q "$1"; then
		echo "Device $1 not found"
		exit 2
	fi
	# query disk passed as param
	query_disk "$1"
else
	# query all disks
	# shellcheck disable=SC2086
	smartctl $SMART_SAT --scan | cut -d\  -f 1 | while read -r DEVICE;
	do
		query_disk "$DEVICE"
	done
fi
