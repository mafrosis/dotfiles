run_segment() {
	ENC=$(ls /dev/mapper | grep "^enc$")
	if [ ! -z "$(df | grep /media/enc)" ]; then
		echo "$ENC*"
	else
		echo $ENC
	fi
	return 0
}
