#!/bin/bash -e


CONF="/etc/freedns.conf"
SHDAEMON="/usr/local/bin/updatednsd.sh"

if [ -e "$HOME/.freednsrc" ]; then
	CONF="$HOME/.freednsrc"
fi

function show {
	echo "Polling time = $POLLTIME"
	echo "Proc ID file = $PIDFILE"
	echo "Proc logfile = $LOGFILE"
	#echo "Update token = $TOKEN"
	echo "D-DNS Domain = $DOMAIN"
	echo
}

function load_conf {

#        echo "Looking for /etc/freedns.conf ..."

        if [ -e "$CONF" ]; then

#               echo "Loading configuration"

		set -- `grep -v ^# $CONF`

		while [ -n "$*" ]; do
			case "$1" in
				"polltime") POLLTIME=$3 ;;
				"pidfile") PIDFILE=$3 ;;
				"logfile") LOGFILE=$3 ;;
				"token") TOKEN=$3 ;;
				"domain") DOMAIN=$3 ;;
				*) echo "Unknown : $1 $2 $3" ;;
			esac
			shift 3
		done
		export POLLTIME PIDFILE LOGFILE TOKEN DOMAIN				

        else
                echo "Configuration file not found. Nothing to load"
                exit 1
        fi
}

function stop_daemon {

	if [ -e "$PIDFILE" ]; then
		if [ -d /proc/`cat $PIDFILE` ]; then
			echo "DNS updater running with PID `cat $PIDFILE`. Stopping"
		else
			echo "DNS updater not running. Removing stale PID file"
		fi
	else
		echo "DDNS updater daemon inactive"
	fi	
	rm $PIDFILE 2> /dev/null
}

function main {
#	show

	("$SHDAEMON" $DOMAIN $TOKEN $POLLTIME >> "$LOGFILE") &

	PID=$!
	echo $PID > $PIDFILE
	sleep 1
	if [ -d /proc/$PID ]; then
		echo "Daemon started successfully with PID $PID"
		exit 0
	else
		echo "Daemon failed to start"
		exit 1
	fi
}


load_conf

case "$1" in 
	start)   main ;;
	restart|reload) stop_daemon; sleep 2; main ;;
	stop) stop_daemon ; sleep 2;;
	status) [ -e "$PIDFILE" ] && echo "PID file found" || { echo "Daemon is NOT running"; exit 1; }
		[ -d /proc/`cat $PIDFILE` ] && echo "Daemon is active" || echo "Daemon is NOT running" ;;
	*) echo "Usage `basename $0` {start|stop|restart|status}" ;;
esac
