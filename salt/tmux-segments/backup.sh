run_segment() {
	ENC=$(ls /dev/mapper | grep "vg_data-lv_enc")
	if [ ! -z "$(df | grep /media/backup)" ]; then
		echo "$ENC*"
	else
		echo $ENC
	fi
	return 0
}
