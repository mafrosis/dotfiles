run_segment() {
	nordvpn status | grep Current | head -1 | cut -d' ' -f 3
	return 0
}
