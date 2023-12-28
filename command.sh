#!/bin/bash

set -euo pipefail

# API endpoint and JSON file. Note that it is a mock server api
API_ENDPOINT="http://localhost:3001/testapi"
USER_STORIES_FILE="user-stories.json"
RESULT_FILE="result.json"

# Function to clear result file and exit with error
exit_with_error() {
    echo "$1" >&2
    buildkite-agent annotate "$1" --style 'error' --context "Assessed result checking"
    > "$RESULT_FILE" # Clear the result file
    exit 1
}

# Get API response and store it
TOKEN="apiToken"
curl -s -H "Authorization: Bearer $TOKEN" -d "USER_STORIES_FILE" "$API_ENDPOINT" > "$RESULT_FILE"

# Validate JSON format of API response
if ! jq empty "$RESULT_FILE" > /dev/null 2>&1; then
    exit_with_error "Error: Invalid JSON format in API response"
fi

# Read user stories count and validate
USER_STORIES_COUNT=$(jq '.user_stories | length' "$USER_STORIES_FILE")
ASSESSED_STORIES_COUNT=$(jq '.user_stories | length' "$RESULT_FILE")

echo "User stories count: $USER_STORIES_COUNT"
echo "Assessed stories count: $ASSESSED_STORIES_COUNT"

if [ "$USER_STORIES_COUNT" -ne "$ASSESSED_STORIES_COUNT" ]; then
    exit_with_error "Error: Mismatch in number of user stories"
fi

echo "Validation successful. Proceeding with further processing..."

# Compare scores and set result
for (( i = 0; i < USER_STORIES_COUNT; i++ )); do
    needed=$(jq --raw-output ".user_stories[$i].needed" "$USER_STORIES_FILE")
    score=$(jq --raw-output ".user_stories[$i].score" "$RESULT_FILE")
    content=$(jq --raw-output ".user_stories[$i].content" "$RESULT_FILE")

    if [ "$score" -ge "$needed" ]; then
        result="success"
    else
        result="error"
        buildkite-agent annotate "$content" --style 'warning' --context "US $i assessed result" --append
    fi

    # Update the result in the RESULT_FILE
    jq ".user_stories[$i] += {\"result\": \"$result\"}" "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

echo "Updated results stored in ${RESULT_FILE}:"
cat "$RESULT_FILE"
