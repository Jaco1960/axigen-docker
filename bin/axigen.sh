#!/bin/bash

# SIGTERM-handler
term_handler() {

    # Stop axigen
    /etc/init.d/axigen stop

    exit 143; # 128 + 15 -- SIGTERM
}

trap 'kill "$tail_pid"; term_handler' INT QUIT KILL TERM

# start the service
echo "Starting axigen service"
/etc/init.d/axigen start

LOGS_FILES="/var/log/dmesg"
for file in $LOGS_FILES; do
	[[ ! -f "$file" ]] && touch $file
done

tail -n0 -F $LOGS_FILES &
tail_pid=$!

# wait "indefinitely"
while [[ -e /proc/$tail_pid ]]; do
    wait $tail_pid # Wait for any signals or end of execution of tail
done

# Stop container properly
term_handler