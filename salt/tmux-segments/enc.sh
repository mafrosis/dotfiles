run_segment() {
	if [[ ! -z $(df | grep /media/enc) ]]; then
		echo "$(df -h | awk '/\/media\/enc$/ {print $4}')"

	elif [[ ! -z $(ls /dev/mapper | grep 'vg_data-lv_enc') ]]; then
		echo 'lv_enc'
	fi
	return 0
}
