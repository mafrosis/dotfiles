run_segment() {
	# display disk usage if mounted
	if df | grep -q /media/backup; then
		df -h | awk '/\/media\/backup$/ {print $4}'

	# else display LVM volume available
	elif ls /dev/mapper/vg_data-lv_backup &>/dev/null; then
		echo 'lv_backup'
	fi
	return 0
}
