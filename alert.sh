#!/bin/bash
function precondition() {
    PATTERN="new_balance[^/]*$"
    fswatch -1 -E -e ".*" -i ".*$PATTERN" . 
}

function action() {
    # play a sound notification
	# afplay /System/Library/Sounds/Glass.aiff

    TEXT="There was a change in the balance of your wallet, please check it out: https://www.mintscan.io/axelar/address/axelar15tpzp26qhuksfp8wcfmq9skljlysnw7n5yny43"
    ./text.sh "$TEXT"
}

precondition && action