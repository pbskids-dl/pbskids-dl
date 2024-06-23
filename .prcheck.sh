#!/bin/bash

# Retrieve the list of checks
checks=$(gh pr checks "$1" --json)

# Filter out the "name2" workflow
filtered_checks=$(echo "$checks" | jq -r '.[] | select(.name != "name2")')

# Print the filtered list of checks
echo "$filtered_checks"
