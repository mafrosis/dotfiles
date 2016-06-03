run_segment() {
	# ensure can sudo
	if ! sudo -l -n | grep -q 'password is required'; then

		# display zpool state
		sudo zpool status | awk '/state:/ {print $2}'

	fi
	return 0
}
