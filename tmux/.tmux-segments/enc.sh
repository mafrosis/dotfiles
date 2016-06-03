run_segment() {
	# display disk usage if mounted
	if df | grep -q /media/enc; then
		df -h | awk '/\/media\/enc$/ {print $4}'

	# else display LVM volume available
	elif ls /dev/mapper/vg_data-lv_enc &>/dev/null; then
		echo 'lv_enc'
	fi
	return 0
}
