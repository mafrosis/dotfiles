# print the current {{ component_name }} pid

run_segment() {
	# check pid file exists
	if [ ! -f "/tmp/{{ component_name }}-{{ pillar['app_name'] }}.pid" ]; then
		echo "DEAD"
		return 0
	fi

	# print the current {{ component_name }} pid
	pgrep -d "," -P $(cat /tmp/{{ component_name }}-{{ pillar['app_name'] }}.pid)

	return 0
}
