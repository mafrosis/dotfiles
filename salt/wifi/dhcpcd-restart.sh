#! /bin/bash

echo 'Checking wifi is up..'

retry=1

until iwconfig 2>/dev/null | grep -q 'wlan0.*ESSID:"bacon"'
do
	printf "DHCPcd has failed, retrying %s\\n" $retry
	systemctl restart dhcpcd
	sleep $((2**retry))
	ip addr show wlan0 | grep '\<inet\>' | tr -s ' ' | cut -d ' ' -f3
	retry=$((retry+1))

	if [[ $retry -eq 3 ]]; then
		exit 44
	fi
done

printf "Connected as %s\\n" "$(ip addr show wlan0 | grep '\<inet\>' | tr -s ' ' | cut -d ' ' -f3)"
