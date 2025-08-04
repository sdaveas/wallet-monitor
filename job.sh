#!/bin/bash
source .env

if [ -z "$ADDRESS" ]; then
    echo "Usage: $0 <address>"
    exit 1
fi    

function run_alert() {
    TEXT="There was a change in the balance of your wallet, please check it out: https://www.mintscan.io/axelar/address/$ADDRESS"
    while true; do
        ./alert.sh "$TEXT"
        sleep 1
    done
}
        
function run_monitor() {
    watch -n 60 -c "./monitor.sh \"$ADDRESS\" \"$RPC\""
}

run_alert &
run_monitor

wait