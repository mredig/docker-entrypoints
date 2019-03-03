#!/usr/bin/env sh

#handle sigterm
_term() { 
	echo "Caught SIGTERM signal!"
	echo "killing pids $child and $myself"
	kill -TERM "$child" 2>/dev/null
	exit 1
}

_int() {
	echo "Caught SIGINT signal!"
	echo "killing pids $child and $myself"
	kill -INT "$child" 2>/dev/null
	exit 0
}

_hup() {
	echo "Caught SIGHUP signal!"
	echo "Triggering another round of $command"
	runCommand
}


runCommand() {
	ps -p "$child" >> /dev/null 2>/dev/null
	processRunning=$?
	# echo "'$child' running: $processRunning"
	if [ "$processRunning" = "0" ]; then
		echo "Process already running, delaying until next attempt"
	else
		$command &
		child=$!
		echo "Started $command as pid $child"
	fi
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


echo "Running repeaterEntrypoint for '$command' with $interval seconds interval." &
child=$!

$preflightCommand

while true 
do
	runCommand

	myself=$$

	trap _term TERM
	trap _int INT
	trap _hup HUP
	sleep 1

	sleepRemain=$interval
	while [ $sleepRemain -gt 0 ]; do
		# echo "Sleeping: $sleepRemain remaining"
		sleep 1
		let sleepRemain=$sleepRemain-1
	done
done

