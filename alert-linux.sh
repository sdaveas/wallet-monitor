#!/bin/bash
TEXT="$1"
if [ -z "$TEXT" ]; then
    echo "Usage: $0 <text>"
    exit 1
fi

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

    ./text.sh "$1"
}

precondition && action "$TEXT"
