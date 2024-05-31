run_segment() {
	nordvpn status | grep Disconnected | cut -d' ' -f 2
	return 0
}
