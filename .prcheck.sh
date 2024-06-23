#!/bin/bash

# Retrieve the list of checks
gh pr checks "$1" --watch --json name,workflow | jq 'map(select(.workflow != "dependabot"))'
