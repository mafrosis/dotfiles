run_segment() {
	# ensure can sudo
	if ! sudo -l -n | grep -q 'password is required'; then

		# display zpool state
		sudo zpool status | grep 'state:' | cut -d' ' -f 3

	fi
	return 0
}
