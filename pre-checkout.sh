#!/bin/bash

sleep 10
RESULT_FILE="testing.json"

# Get the comma-separated list of IDs
ID_LIST=$(buildkite-agent meta-data get us)
echo "Received IDs: $ID_LIST"

# Validate that ID_LIST contains only numbers and commas
if ! [[ $ID_LIST =~ ^[0-9,]+$ ]]; then
    echo "Error: ID list must contain only numbers separated by commas."
    buildkite-agent annotate "Failed: Incorrect input User Story Number. Only with ID seperated by comma." --style 'error' --context 'user-stories-checking'
    exit 1
fi

# Convert the string of IDs into an array
IFS=',' read -r -a ids <<< "$ID_LIST"

# Read the user-stories.json file
USER_STORIES=$(cat user-stories.json)

# Prepare an empty array for filtered user stories
FILTERED_STORIES=()
UNMATCHED_IDS=()

for id in "${ids[@]}"; do
    # Extract the user story with the matching ID
    USER_STORY=$(echo "$USER_STORIES" | jq --arg id "$id" '.user_stories[] | select(.id == ($id | tonumber))')
    if [ ! -z "$USER_STORY" ]; then
        # Append the story to the filtered stories array
        FILTERED_STORIES+=("$USER_STORY")
    else
        # Add to unmatched IDs list
        UNMATCHED_IDS+=("$id")
    fi
done

# Check for unmatched IDs
if [ ${#UNMATCHED_IDS[@]} -ne 0 ]; then
    echo "Error: The following IDs did not match any user stories: ${UNMATCHED_IDS[*]}"
    buildkite-agent annotate "Failed: Invalid input ID." --style 'error' --context 'user-stories-checking'
    exit 1
fi

# Combine filtered stories into a single JSON array
FILTERED_STORIES_JSON=$(printf '%s\n' "${FILTERED_STORIES[@]}" | jq -s .)

# Reconstruct the JSON with the original structure but with filtered user stories
echo "$USER_STORIES" | jq --argjson stories "$FILTERED_STORIES_JSON" '.user_stories = $stories' > "$RESULT_FILE"

echo "Filtered user stories stored in $RESULT_FILE: "
cat "$RESULT_FILE"

buildkite-agent annotate "Success: Valid input ID of User Story." --style 'success' --context 'ID-checking'

sleep 5