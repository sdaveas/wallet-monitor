#!/bin/bash

RPC="https://rest.lavenderfive.com:443"
ADDRESS="axelar15tpzp26qhuksfp8wcfmq9skljlysnw7n5yny43"

STATS_FILE="stats.txt"
NEW_STATS_FILE="new_stats.txt"

function check_stats() {
    get_stats
    compare_stats
}

function get_stats() {
	AVAILABLE_AXL=$(curl -s "$RPC/axelar/cosmos/bank/v1beta1/balances/$ADDRESS" | jq -r '.balances[] | select(.denom == "uaxl") | (.amount | tonumber / 1000000)')
	DELEGATED_AXL=$(curl -s "$RPC/axelar/cosmos/staking/v1beta1/delegations/$ADDRESS" | jq -r '.delegation_responses[0].balance.amount | tonumber / 1000000')
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
    get_stats > $NEW_STATS_FILE

    DIFF=$(diff $STATS_FILE $NEW_STATS_FILE) || echo "creating new stats file" && cp $NEW_STATS_FILE $STATS_FILE

    if [ -z "$DIFF" ]; then
        echo "No changes detected."
        rm $NEW_STATS_FILE
    else
        echo "Changes detected:"
        echo "$DIFF"
        cp $NEW_STATS_FILE "$(date +%Y-%m-%d_%H:%M:%S).txt"
        mv $NEW_STATS_FILE $STATS_FILE
    fi
}

check_stats