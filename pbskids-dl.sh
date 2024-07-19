#!/usr/bin/env bash
#
# Bash Script for downloading PBS KIDS videos.
#
# Requirements for this script: curl, awk, sed and aria2
#
# Usage:
# pbskids-dl [url]
# Where url is the page you land on when 
# a video is playing. 
#
# Made by NexusSfan
#
#
# License:
#
#    pbskids-dl
#    Copyright (C) 2024 The pbskids-dl Team
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

if (( $# != 1 )); then
    echo "Improper command! Type --help for more info."
    exit
fi

rawurl=($1)
if [ "$1" == "--help" ]; then
    echo "pbskids-dl v2.3"
    echo "Sadly, pbskids-dl.sh is EOF. For more info, visit https://github.com/pbskids-dl/pbskids-dl/wiki/pbskids-dl.sh-EOF"
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
    vid_title=`echo $vid_name".mp4" | sed "s+\"+_+g" | sed "s_/_+_g"`
    echo $vid_title
    echo "Downloading Video..."
    aria2c "$realvid" -o "$vid_title"
    echo "The operation completed."
    exit
else
    echo "Improper URL! Type --help for more info."
    exit
fi
