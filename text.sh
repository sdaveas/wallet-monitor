#!/bin/bash
source .env

if [ -z "$BOT_TOKEN" ]; then
    echo "BOT_TOKEN is not set. Please set BOT_TOKEN environment variable."
    exit 1
fi

if [ -z "$CHAT_ID" ]; then
    echo "CHAT_ID is not set. Please set CHAT_ID environment variable."
    exit 1
fi

TEXT="$1"
if [ -z "$TEXT" ]; then
    echo "Usage: $0 <text>"
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
     -d chat_id="$CHAT_ID" \
     -d text="$TEXT"