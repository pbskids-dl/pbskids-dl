#!/usr/bin/bash
#
# Bash Script for downloading PBS KIDS videos.
#
# Requirements for this script: curl, awk, and sed
#
# Usage:
# pbskids-dl [url]
# where url is the page you land on when 
# a video is playing. 
#
# Made by NexusSfan

if (( $# != 1 )); then
    echo "Improper command! Type --help for more info."
    exit
fi

rawurl=($1)
if [ "$1" == "--help" ]; then
    echo "PBSKIDS DL v2.2 (geometry dash moment)"
    echo "A tool for downloading PBS KIDS videos"
    echo "Usage: pbskids-dl [url]"
    exit
fi

echo "Extracting URL:" $rawurl

# Fetch the titles and links,
# and URLs that ffmpeg can use.
# Store them in lists in memory!
echo "Getting Webpage..."
deeplink=`curl -s $rawurl | grep DEEPLINK`
if [ -n "$deeplink" ]; then
    echo "Improper URL! Type --help for more info."
    exit
fi
echo "Setting up variables..."
vid_name=`echo $deeplink | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+\ -\ +g" |  sed "s/[\]//g"`
realvid=`echo $deeplink | awk -F "," '{print $8}' | awk -F "\"" '{print $4}' | sed "s/[\]//g"`
title=`echo $deeplink | awk -F "," '{print $24}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+-+g" |  sed "s/[\]//g"`
vid_title=`echo $title": "$vid_name".mp4" | sed "s+\"+_+g"`
echo $vid_title
echo "Downloading Video..."
curl "$realvid" > "$vid_title"
echo "The operation completed."
