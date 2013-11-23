#!/bin/bash


function abort {
	echo "Error: $@"
	exit 1
}

function show {
	echo "Token : $TOKEN"
	echo "Domain: $DOMAIN"
}

function poll_domain {

	URL="http://freedns.afraid.org/dynamic/update.php?$TOKEN"

	cur_ip=`wget -qO - http://textbox37.appspot.com/myip`
	dom_ip=`dig $DOMAIN @8.8.8.8 | grep ^$DOMAIN | awk '{ print $5 }'`

	if [ "$cur_ip" != "$dom_ip" ]; then
		echo "[$(date)] $(wget -q -O - "$URL")"
	else
		echo "[$(date)] No update"
	fi
}


DOMAIN="$1"
TOKEN="$2"
POLLTIME="$3"

[ "$TOKEN" = "" ]  && abort "No private token"
[ "$DOMAIN" = "" ] && abort "Domain name unspecified"
[ "$POLLTIME" = "" ] && abort "Polling frequency unspecified"


while true; do
	poll_domain
	sleep $POLLTIME
done
