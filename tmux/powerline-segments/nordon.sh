run_segment() {
	HOSTNAME=$(nordvpn status | grep Hostname | cut -d' ' -f 2)
	if [[ -n $HOSTNAME ]]; then
		echo "$HOSTNAME"
	fi
	return 0
}
