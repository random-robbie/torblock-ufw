#!/bin/bash
FILE=/tmp/fullnew.tor
echo -e "\n\tChecking if the file exists...\n"
if test -f "$FILE"; then
    echo -e "\n\tFile exists... Moving it and Downloading the updated file\n"
	mv /tmp/fullnew.tor /tmp/fullold.tor
	wget -q -O - https://www.dan.me.uk/torlist/ > /tmp/fullnew.tor
	echo -e "\n\tLets add the new ips to the firewall...\n"
	CMD=$(comm -23 /tmp/fullnew.tor  /tmp/fullold.tor)
	for IP in $CMD; do
		let COUNT=COUNT+1
		ufw deny from $IP
	done
	echo -e "\n\tRemoving ips from the firewall that are not part of the tor network...\n"
	CMD=$(comm -23 /tmp/fullold.tor  /tmp/fullnew.tor)
	for IP in $CMD; do
		let COUNT=COUNT+1
		iptables -D ufw-user-input -s $IP -j DROP
	done
else
	echo -e "\n\tFile not found... Downloading it...\n"
	wget -q -O - https://www.dan.me.uk/torlist/ > /tmp/fullnew.tor
	CMD=$(cat /tmp/full.tor | uniq | sort)
	for IP in $CMD; do
		let COUNT=COUNT+1
		ufw deny from $IP
	done
	echo -e "\n\tUFW now blocking TOR connections !\n"
	echo -e "Allowing Nginx and SSH through Firewall..."
	ufw allow 'Nginx full'
	ufw allow ssh
fi
echo -e "\n\tEverything done...Take care\n"
