#!/bin/bash

# Retrieve the list of checks
checks=$(gh pr checks "$1" --watch --json)

# Filter out the "dependabot" workflow
filtered_checks=$(echo "$checks" | jq -r '.[] | select(.name != "dependabot")')

# Print the filtered list of checks
echo "$filtered_checks"
