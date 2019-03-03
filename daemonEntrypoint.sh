#!/usr/bin/env sh

#handle sigterm
_term() { 
	echo "Caught SIGTERM signal!"
	kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM


command='pwd'
preflightCommand=''

while getopts ":i:c:p:" flag
do
	if [ "$flag" = "c" ] ; then
		command=$OPTARG
	fi
	if [ "$flag" = "p" ] ; then
		preflightCommand=$OPTARG
	fi
	if [ "$flag" = "?" ] ; then
		echo "Usage: ./daemonEntrypoint.sh -c [command to run (use quotes if there are spaces)] -p [preflight command]"
		exit 1
	fi
done

$preflightCommand

$command &
child=$!
echo "Started $command as pid $child"

wait $child