# Docker Entrypoints

I figured that there are two quite common scenarios with Docker containers to have them run a script at repeated intervals, or to start up a daemon and leave it be. There's also the common use case to want to run something prior to starting the main priority, so I created a pair of shell scripts as easy templates.

### repeaterEntrypoint.sh

This script can almost be used like a cron job, but much more limited. Every x seconds, it will run a command of your choosing and then sleep for an interval specified. The command it runs is run in the background and COULD overlap with the next trigger if it takes a while. There is room for improvement here.

### daemonEntrypoint.sh

This script basically just starts a daemon and leaves it be.


### Both Scripts

Both scripts remain running for the lifetime of the docker container and have the option to run a preflight command. Using these as your entrypoint scripts also would allow you to hack some convenient changes into your `docker-compose.yml` file by squeezing some one-liner magic into the preflight before running the main command. The only requirement is using either of these as the entrypoing in your `Dockerfile` first.