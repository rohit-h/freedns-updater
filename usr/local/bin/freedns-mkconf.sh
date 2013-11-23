#!/bin/bash

echo -e "DDNS updater configuration\n----------------------------"

echo -n "Domain name: "
read DOMAIN

echo -n "Update token: "
read TOKEN

echo -n "Polling time (in seconds) [120]: "
read POLLTIME

[ "$POLLTIME" = "" ] && POLLTIME=120

echo -ne "\nEnter filename to save configuration to: "
read FILENAME
[ "$FILENAME" = "" ] && FILENAME="$HOME/.freednsrc"

echo "
domain = $DOMAIN
token = $TOKEN
polltime = $POLLTIME
pidfile = /tmp/freedns.pid
logfile = /tmp/freedns.log
" > "$FILENAME"

echo "Configuration written to $FILENAME"
