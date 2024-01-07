#!/bin/bash

sleep 5
RESULT_FILE="testing.json"

# Get the comma-separated list of IDs
ID_LIST=$(buildkite-agent meta-data get us)
echo "Received IDs: $ID_LIST"

# Convert the string of IDs into an array
IFS=',' read -r -a ids <<< "$ID_LIST"

# Read the user-stories.json file
USER_STORIES=$(cat user-stories.json)

# Prepare an empty array for filtered user stories
FILTERED_STORIES=()

for id in "${ids[@]}"; do
    # Extract the user story with the matching ID
    USER_STORY=$(echo "$USER_STORIES" | jq --arg id "$id" '.user_stories[] | select(.id == ($id | tonumber))')
    if [ ! -z "$USER_STORY" ]; then
        # Append the story to the filtered stories array
        FILTERED_STORIES+=("$USER_STORY")
    fi
done

# Combine filtered stories into a single JSON array
FILTERED_STORIES_JSON=$(printf '%s\n' "${FILTERED_STORIES[@]}" | jq -s .)

# Reconstruct the JSON with the original structure but with filtered user stories
echo "$USER_STORIES" | jq --argjson stories "$FILTERED_STORIES_JSON" '.user_stories = $stories' > "$RESULT_FILE"

echo "Filtered user stories stored in $RESULT_FILE: "
cat "$RESULT_FILE"

sleep 5