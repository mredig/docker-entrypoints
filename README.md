# Docker Entrypoints

I figured that there are two quite common scenarios with Docker containers to have them run a script at repeated intervals, or to start up a daemon and leave it be. There's also the common use case to want to run something prior to starting the main priority, so I created a pair of shell scripts as easy templates.

### repeaterEntrypoint.sh

This script can almost be used like a cron job, but much more limited. Every x seconds, it will run a command of your choosing and then sleep for an interval specified. The command is run in the background and then the script repeats `sleep 1` for the number of seconds you have set for an interval. I don't know this for certain, but I wouldn't expect it to be like perfect clockwork, think of it more as "*about* $interval seconds between running the commmand".

Every time the command is triggered, a check is run to see if it's already running from the prevoius attempt. If it is already running, it will simply not fire and wait until the next interval comes around to try again. If you want to manually trigger an additional run of $command, you may send the HUP signal to repeaterEntrypoint.sh. (`kill -s HUP [pidForRepeaterEntrypoint]`). Again, there is a check in place to make sure $command does not overlap with itself.

##### Example:
`./repeaterEntrypoint.sh -i 5 -c "ping google.com -c 10"` and you will see how this plays out

### daemonEntrypoint.sh

This script basically just starts a daemon and leaves it be. SIGTERM, SIGINT, and SIGHUP are passed through to the child process.


### Both Scripts

Both scripts remain running for the lifetime of the docker container and have the option to run a preflight command. Using these as your entrypoint scripts also would allow you to hack some convenient changes into your `docker-compose.yml` file by squeezing some one-liner magic into the preflight before running the main command. The only requirement is using either of these as the entrypoing in your `Dockerfile` first.