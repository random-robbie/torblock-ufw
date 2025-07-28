#!/bin/bash

# Define the path for the Tor exit node list
TOR_LIST_FILE="/tmp/fullnew.tor"
OLD_TOR_LIST_FILE="/tmp/fullold.tor"
TOR_LIST_URL="https://www.dan.me.uk/torlist/"

echo -e "\n\tChecking for existing Tor exit node list...\n"

if test -f "$TOR_LIST_FILE"; then
    echo -e "\n\tExisting file found. Moving it and downloading updated list...\n"
    mv "$TOR_LIST_FILE" "$OLD_TOR_LIST_FILE"

    # Download the new Tor exit node list
    if ! wget -q -O - "$TOR_LIST_URL" > "$TOR_LIST_FILE"; then
        echo -e "\n\tERROR: Failed to download the Tor exit node list. Aborting.\n"
        exit 1
    fi

    echo -e "\n\tAdding new Tor IPs to UFW...\n"
    # Find IPs that are in the new list but not in the old list (newly added Tor nodes)
    NEW_IPS=$(comm -23 "$TOR_LIST_FILE" "$OLD_TOR_LIST_FILE")
    for IP in $NEW_IPS; do
        ufw deny from "$IP"
    done

    echo -e "\n\tRemoving old Tor IPs from UFW...\n"
    # Find IPs that are in the old list but not in the new list (nodes no longer Tor exit nodes)
    OLD_IPS=$(comm -23 "$OLD_TOR_LIST_FILE" "$TOR_LIST_FILE")
    for IP in $OLD_IPS; do
        # Use iptables directly to remove specific rules, as 'ufw delete' can be problematic in scripts
        # This command specifically targets rules added by 'ufw deny from IP'
        iptables -D ufw-user-input -s "$IP" -j DROP
    done
else
    echo -e "\n\tNo existing file found. Downloading initial Tor exit node list...\n"
    # Download the initial Tor exit node list
    if ! wget -q -O - "$TOR_LIST_URL" > "$TOR_LIST_FILE"; then
        echo -e "\n\tERROR: Failed to download the Tor exit node list. Aborting.\n"
        exit 1
    fi

    echo -e "\n\tAdding all Tor IPs to UFW...\n"
    # Read all unique and sorted IPs from the downloaded file
    ALL_IPS=$(cat "$TOR_LIST_FILE" | uniq | sort)
    for IP in $ALL_IPS; do
        ufw deny from "$IP"
    done

    echo -e "\n\tUFW is now blocking TOR connections!\n"
    echo -e "\n\tInitial UFW setup (allowing Nginx and SSH if not already allowed)...\n"
    # These rules are typically for the initial setup of UFW
    ufw allow 'Nginx full'
    ufw allow ssh
fi

echo -e "\n\tTor blocking script finished. Take care!\n"

