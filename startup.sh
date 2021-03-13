#!/bin/bash

# Terminate Flag : An alternative method for terminating the repeatable loop
# Can be used to terminate the script when the "Repeatable" function is keeping
# The script active
TERMFLAG=/tmp/terminate.flag

# Used to kill any exectuable that is keeping this script going (if PID can be obtained)
PIDP=""

# RUNCMD Flag : If not empty/null, run this instead of Repeatable root
# RUNCMD

# If Proxy settings are needed (Replace items in brackets "[]")
#PROXY=[proxy DNS/IP]:[port]

#http_proxy=http://${PROXY}
#https_proxy=https://${PROXY}

#export http_proxy
#export https_proxy

# Clean Child Processes and Other Minutia
function CleanUp()
{
	kill %Repeatable

	# Cleanup code goes here

	if [ ! "${PIDP}" = "" ]; then
		kill -s TERM ${PIDP}
	fi
}

# Function designed to be called periodically by main loop
# This function respects the terminate flag and sleep for
# a period of time, to prevent constant execution and driving
# up the consumed CPU cycles.
# It would be best to leave the terminate conditions in, but
# feel free to modify the sleep time.
function Repeatable()
{
	while [ ! -f "${TERMFLAG}" ]; do
		timestamp=$(date "+%Y%m%d_%H%M%S")

		# Do something

		sleep 5m
	done

	if [ -f "${TERMFLAG}" ]; then
		rm "${TERMFLAG}"
		CleanUp
	fi
}

# Since you have elected to run this script, it is important to note that this script must not
# terminate until it is needed to. When the script terminates, the container shuts down.

# If the following signals are recieved, assume the container has been asked to shut down
# As such, run the CleanUp function to bring down the container gracefully
trap CleanUp HUP INT QUIT TERM

# Two Operation Modes
#
# You can call the 'Repeatable' function and it will handle all the internal processes required AND keep the container
# running.
#
# OR
#
# You can put any required housekeeping functions/customizations in the 'Repeatable' function and background it.
# *** IF *** you background the 'Repeatble' function, YOU MUST execute something after that to keep the container
# running. Otherwise it WILL terminate.
# You can run another function, process or daemon, BUT they must all be in the foreground and terminate gracefully
#
# Both examples are given below
#

# ***************************
# Background Repeatable with interactive daemon
#

#Repeatable &

# Execute something that won't terminate
#/usr/sbin/apachectl -D FOREGROUND

# ***************************
# Leave Repeatable Running
#
# ** If a RUNCMD is defined, then it will be executed instead of 'Repeatable'. Be sure the item defined in RUNCMD
# ** Will remaining running until asked to terminate and then gracefully exit.

[ "${RUNCMD}" = "" ] && Repeatable
[ ! "${RUNCMD}" == "" ] && ${RUNCMD}
