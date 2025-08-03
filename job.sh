#!/bin/bash
source .env

if [ -z "$ADDRESS" ]; then
    echo "Usage: $0 <address>"
    exit 1
fi    

function run_alert() {
    while true; do
        ./alert.sh
        sleep 1
    done
}
        
function run_monitor() {
    watch -n 60 -c "./monitor.sh \"$ADDRESS\""
}

run_alert &
run_monitor

wait