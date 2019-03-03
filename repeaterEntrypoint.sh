#!/usr/bin/env sh

#handle sigterm
_term() { 
	echo "Caught SIGTERM signal!"
	kill -TERM "$child" 2>/dev/null
}



interval=60
command='pwd'
preflightCommand=''

while getopts ":i:c:p:" flag
do
	if [ "$flag" = "i" ] ; then
		interval=$OPTARG
	fi
	if [ "$flag" = "c" ] ; then
		command=$OPTARG
	fi
	if [ "$flag" = "p" ] ; then
		preflightCommand=$OPTARG
	fi
	if [ "$flag" = "?" ] ; then
		echo "Usage: ./repeaterEntrypoint.sh -i [interval in seconds between firing command] -c [command to run (use quotes if there are spaces)] -p [preflight command]"
		exit 1
	fi
done

$preflightCommand

while true 
do
	$command &
	child=$!
	echo "Started $command as pid $child"

	trap _term TERM
	
	sleep $interval
done

