#!/usr/bin/env bash
#
# Bash Script for downloading PBS KIDS videos.
#
# Requirements for this script: curl, awk, aria2, and sed
#
# Usage:
# pbskids-dl [url]
# Where url is the page you land on when 
# a video is playing. 
#
# Made by NexusSfan

if (( $# != 1 )); then
    echo "Improper command! Type --help for more info."
    exit
fi

rawurl=($1)
if [ "$1" == "--help" ]; then
    echo "PBSKIDS DL v3.0"
    echo "A tool for downloading PBS KIDS videos"
    echo "Usage: pbskids-dl [url]"
    exit
fi

echo "Extracting URL:" $rawurl

echo "Getting Webpage..."
deeplink=`curl -s $rawurl | grep __NEXT_DATA__`
if [ -n "$deeplink" ]; then
    echo "Setting up variables..."
    vid_name=`echo $deeplink | awk -F "," '{print $9}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+\ -\ +g" |  sed "s/[\]//g"`
    realvid=`echo $deeplink | awk -F "," '{print $8}' | awk -F "\"" '{print $4}' | sed "s/[\]//g"`
    title=`echo $deeplink | awk -F "," '{print $24}' | awk -F "\"" '{print $4}' | sed "s/[\]//g" | sed "s+/+-+g" |  sed "s/[\]//g"`
    vid_title=`echo $title": "$vid_name".mp4" | sed "s+\"+_+g"`
    echo $vid_title
    echo "Downloading Video..."
    aria2c "$realvid" -o "$vid_title"
    echo "The operation completed."
    exit
else
    echo "Improper URL! Type --help for more info."
    exit
fi
