#!/bin/bash
ADDRESS="$1"
if [ -z "$ADDRESS" ]; then
    echo "Usage: $0 <address>"
    exit 1
fi

RPC="https://rest.lavenderfive.com:443"

STATS_FILE="stats.txt"
NEW_STATS_FILE="new_stats.txt"

function check_stats() {
    get_stats
    compare_stats
}

function get_stats() {
	AVAILABLE_AXL=$(curl -s "$RPC/axelar/cosmos/bank/v1beta1/balances/$ADDRESS" | jq -r '.balances[] | select(.denom == "uaxl") | (.amount | tonumber / 1000000)')
    # if curl response contains "Invalid numeric literal at line 1" then the RPC hit rate limit
    if [[ $? -ne 0 ]]; then
        echo "Error fetching data from RPC. Please check the RPC endpoint or your network connection."
        exit 1
    fi

	DELEGATED_AXL=$(curl -s "$RPC/axelar/cosmos/staking/v1beta1/delegations/$ADDRESS" | jq -r '.delegation_responses[0].balance.amount | tonumber / 1000000')
    if [[ $? -ne 0 ]]; then
        echo "Error fetching data from RPC. Please check the RPC endpoint or your network connection."
        exit 1
    fi

	TOTAL_AXL=$(bc -l <<< "$AVAILABLE_AXL + $DELEGATED_AXL")

	echo "------------------------------"
	echo "Address: $ADDRESS"
	echo "------------------------------"
	printf "%9.2f" "$AVAILABLE_AXL"
	printf " AXL available\n"
	printf "%9.2f" "$DELEGATED_AXL"
	printf " AXL delegated\n"
	echo "------------------------------"
	printf "%9.2f" "$TOTAL_AXL"
	printf " AXL total\n"
}

function compare_stats() {
    get_stats "$ADDRESS" > $NEW_STATS_FILE

    if [ ! -f $STATS_FILE ]; then
        echo "No previous stats file found. Creating one."
        cp $NEW_STATS_FILE $STATS_FILE
        mv $NEW_STATS_FILE "new_balance_$(date +%Y-%m-%d_%H:%M:%S).txt"
        return
    fi

    DIFF=$(diff $STATS_FILE $NEW_STATS_FILE)

    if [ -z "$DIFF" ]; then
        echo "No changes detected."
        rm $NEW_STATS_FILE
    else
        echo "Changes detected:"
        echo "$DIFF"
        cp $STATS_FILE "new_balance_$(date +%Y-%m-%d_%H:%M:%S).txt"
        mv $NEW_STATS_FILE $STATS_FILE
    fi
}

check_stats