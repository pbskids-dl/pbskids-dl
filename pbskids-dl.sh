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
    vid_name=`echo $deeplink | awk -F ">" '{print $4}' | awk -F "<" '{print $1}' | awk -F " Video" '{print $1}'`
    realvid=`echo $deeplink | awk -F "mp4-16x9-baseline" '{print $2}' | awk -F "\"" '{print $5}'`
    vid_title=`echo ""$vid_name".mp4" | sed "s+\"+_+g" | sed "s_/_+_g"`
    echo $vid_title
    echo "Downloading Video..."
    aria2c "$realvid" -o "$vid_title"
    echo "The operation completed."
    exit
else
    echo "Improper URL! Type --help for more info."
    exit
fi
