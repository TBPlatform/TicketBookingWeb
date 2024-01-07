#!/bin/bash

sleep 10

# Get the comma-separated list of IDs
ID_LIST=$(buildkite-agent meta-data get us)
echo "Received IDs: $ID_LIST"

# Convert the string of IDs into an array
IFS=',' read -r -a ids <<< "$ID_LIST"

# Read the user-stories.json file
USER_STORIES=$(cat user-stories.json)

# Decode JSON and filter based on IDs
echo "[]" > testing.json # Initialize testing.json with an empty array

for id in "${ids[@]}"; do
    # Extract the user story with the matching ID and append to testing.json
    USER_STORY=$(echo "$USER_STORIES" | jq --arg id "$id" '.user_stories[] | select(.id == ($id | tonumber))')
    if [ ! -z "$USER_STORY" ]; then
        # Append to testing.json
        jq -s '.[0] + [.[1]]' testing.json <(echo "$USER_STORY") > temp.json && mv temp.json testing.json
    fi
done

echo "Filtered user stories stored in testing.json"

sleep 5