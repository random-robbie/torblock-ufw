#!/bin/bash
echo -e "Clearing all firewall rules..."
ufw reset
ufw enable
echo -e "\n\tGetting Tor node list from dan.me.uk\n"
wget -q -O - https://www.dan.me.uk/torlist/ > /tmp/full.tor
CMD=$(cat /tmp/full.tor | uniq | sort)
for IP in $CMD; do
    let COUNT=COUNT+1
    ufw deny from $IP
done
echo -e "\n\tUFW now blocking TOR connections !\n"
echo -e "Allowing Nginx and SSH through Firewall..." 
ufw allow 'Nginx full'
ufw allow ssh
echo -e "Everything done...Take care"
