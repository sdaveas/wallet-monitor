#!/bin/bash
TEXT="$1"
if [ -z "$TEXT" ]; then
    echo "Usage: $0 <text>"
    exit 1
fi

function precondition() {
    PATTERN="new_balance[^/]*$"
    fswatch -1 -E -e ".*" -i ".*$PATTERN" . 
}

function action() {
    # play a sound notification
	# afplay /System/Library/Sounds/Glass.aiff

    ./text.sh "$1"
}

precondition && action "$TEXT"