run_segment() {
	if [[ ! -z $(df | grep /media/backup) ]]; then
		echo "$(df -h | awk '/\/media\/backup$/ {print $4}')"

	elif [[ ! -z $(ls /dev/mapper | grep 'vg_backup-lv_backup') ]]; then
		echo 'lv_backup'
	fi
	return 0
}
