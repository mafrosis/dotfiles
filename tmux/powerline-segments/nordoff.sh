run_segment() {
	nordvpn status | grep Disconnected | cut -d' ' -f 6
	return 0
}
