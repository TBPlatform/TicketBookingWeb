#!/bin/bash
set -euo pipefail

FILE_NAME="user-stories.json"
EXPECTED_PATTERN='.user_stories[] | select(.id and .content and .needed and .weight) | .content'

# Check if the file exists
if [ ! -f "$FILE_NAME" ]; then
    echo "Error: File ${FILE_NAME} not found."
    buildkite-agent annotate "Failed: Invalid pre-command checking." --style 'error' --context 'user-stories-checking'
    exit 1
fi

# Check the format and extract the content of user stories
if ! jq "$EXPECTED_PATTERN" "$FILE_NAME" > /dev/null 2>&1; then
    echo "Error: The format of ${FILE_NAME} is incorrect or the file is not valid JSON."
    buildkite-agent annotate "Failed: Invalid pre-command checking." --style 'error' --context 'user-stories-checking'
    exit 1
fi

# Echo the contents of user stories
echo "User stories from ${FILE_NAME}:"
jq "$EXPECTED_PATTERN" "$FILE_NAME"

buildkite-agent annotate "Success: Valid user stories checking." --style 'success' --context 'user-stories-checking'
