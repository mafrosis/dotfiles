#! /bin/bash

USAGE='diskinfo.sh [-v] [-h] [device]

  -v	verbose printing
  -S	support SMART via USB (passes -d sat to smartctl)
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


# install dependencies
if ! command -v smartctl &>/dev/null || ! command -v disktype &>/dev/null; then
	aptitude install smartmontools disktype
	if [[ $? -eq 1 ]]; then
		echo 'Unable to install smartctl and disktype'
		exit 2
	fi
fi

declare -A DISKMAP

function query_disk {
	local DEVICE="$1"

	# extract hardware info from smartctl
	# shellcheck disable=SC2086
	INFO="$(smartctl $SMART_SAT --info "$DEVICE")"
	MODEL="$(echo "$INFO" | grep 'Device Model' | cut -d' ' -f 3- | xargs)"
	SERIAL="$(echo "$INFO" | awk '/Serial Number/ {print $3}')"
	FIRMWARE="$(echo "$INFO" | awk '/Firmware/ {print $3}')"
	SIZE="$(echo "$INFO" | awk '/User Capacity/ {print substr($5,2) substr($6,1,length($6)-1)}')"

	# display disk header
	echo "========== $DEVICE =========="
	echo -e "Model:\t\t$MODEL"
	if [[ $VERBOSE -eq 1 ]]; then
		echo -e "Serial:\t\t$SERIAL" | grep --color "$SERIAL"
	else
		echo -e "Serial\t\t$SERIAL"
	fi
	echo -e "WWN:\t\t${DISKMAP[$DEVICE]}"
	echo -e "Firmware:\t$FIRMWARE"
	echo -e "Size:\t\t$SIZE"

	if [[ $VERBOSE -eq 0 ]]; then
		echo '' && return
	fi

	# print partition info from disktype
	echo -e "\n---- Partitions ----------"
	disktype "$DEVICE" | awk 'NF && ! /^--/'

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
		if [[ ! -z "$(pvdisplay 2>/dev/null | awk -v var="$DEVICE" '$0 ~ var')" ]]; then
			echo -e "\n---- LVM Volumes ---------"

			# iterate Volume Groups on this device
			pvdisplay "$DEVICE" | awk '/VG Name/ {print $3}' | while read -r VG_NAME;
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

# query all disks for smart data
# shellcheck disable=SC2086
SMART_DATA=$(smartctl $SMART_SAT --scan | cut -d\  -f 1)

# get list of WWN* disks
# shellcheck disable=SC2010
WWN_DRIVES="$(ls /dev/disk/by-id/wwn* | grep -v part)"

for DEVICE in $SMART_DATA; do
	# extract Disk GUID
	DISK_GUID="$(disktype "$DEVICE" | awk '/Disk GUID/ {print $3}')"

	#echo "D:$DISK_GUID"
	# iterate wwn* disks and match by Disk GUID
	for D in $WWN_DRIVES; do
		WWN_DISK_GUID=$(disktype "$D" | awk '/Disk GUID/ {print $3}')

		#echo "G:$WWN_DISK_GUID"
		if [[ $WWN_DISK_GUID = "$DISK_GUID" ]]; then
			DISKMAP[$DEVICE]=${D##*/}
			break
		fi
	done

	# display info for all disks
	if [[ $# -eq 0 ]]; then
		query_disk "$DEVICE"
	fi
done

if [[ $# -eq 1 ]]; then
	# query disk passed as param
	query_disk "$1"
fi
