#!/bin/bash
if [ -z "$1" ]; then
    echo "Usage: $0 <file_with_urls>"
    exit 1
fi
while IFS= read -r arg; do
    pbskids-dl $arg
    if [ $? -ne 0 ]; then
	echo "Error: Command failed with exit code $?. Exiting script."
	exit 1
    fi
done < "$1"
