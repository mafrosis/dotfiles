run_segment() {
	STATUS=$(nordvpn status | grep Disconnected | cut -d' ' -f 4)
	if [[ -n $STATUS ]]; then
		echo 'Disconnected'
	else
		if nordvpn status | grep -q Connected; then
			return 1
		fi
		echo 'Logged out'
	fi
	return 0
}
