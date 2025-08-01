#!/bin/bash
function precondition() {
    # Use inotifywait instead of fswatch for Linux compatibility
    # Monitor for new files matching the pattern new_balance*
    inotifywait -m -e create,moved_to --format '%f' ./data | while read filename; do
        if [[ "$filename" =~ ^new_balance.*$ ]]; then
            echo "Detected change: $filename"
            return 0
        fi
    done
}

function action() {
    # play a sound notification (commented out as not available in container)
	# afplay /System/Library/Sounds/Glass.aiff

    TEXT="There was a change in the balance of your wallet, please check it out: https://www.mintscan.io/axelar/address/axelar15tpzp26qhuksfp8wcfmq9skljlysnw7n5yny43"
    ./text.sh "$TEXT"
}

precondition && action
