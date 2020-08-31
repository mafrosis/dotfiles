#! /bin/bash -ex

if ! grep novpn /etc/iproute2/rt_tables &>/dev/null; then
	echo "201 novpn" >> /etc/iproute2/rt_tables
fi

if ! ip rule show | grep fwmark &>/dev/null; then
	# add netfilter for my route table
	ip rule add fwmark 65 table novpn
fi

if ! ip route | grep default via 192.168.1.1 dev enp2s0 &>/dev/null; then
	# route all traffic to local gateway LAN interface
	ip route add default via 192.168.1.1 dev enp2s0 table novpn
	ip route flush cache
fi

if ! iptables -t mangle --list-rules | grep -- '-A OUTPUT -p tcp -m tcp --sport 22' &>/dev/null; then
	# direct all port 22 traffic to netfilter number 65
	iptables -t mangle -A OUTPUT -p tcp --sport 22 -j MARK --set-mark 65
fi

if ! iptables --list-rules | grep -- '-A INPUT -i tun0 -p tcp -m tcp --dport 22 -j DROP' &>/dev/null; then
	# drop incoming SSH connections on the VPN
	iptables -A INPUT -i tun0 -p tcp -m tcp --dport 22 -j DROP
fi
