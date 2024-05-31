#!/usr/bin/env python3

#thank you PR 15

import argparse
import urllib.request, urllib.error, urllib
from bs4 import BeautifulSoup
import json

def handle_progress(chunk_number, chunk_size, total_size):
    total_chunk = total_size / chunk_size
    length = 50
    decimals = 1
    prefix = 'Downloading:'
    suffix = ''
    percent = ("{0:." + str(decimals) + "f}").format(100 * (chunk_number / float(total_chunk)))
    filledLength = int(length * chunk_number // total_chunk)
    bar = '█' * filledLength + ' ' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}', end = "\r")
    if chunk_number == total_chunk: 
        print()


parser = argparse.ArgumentParser(prog='pbskids-dl', description='A tool for downloading PBS KIDS videos.', epilog='Made by NexusSfan')
parser.add_argument('url', help='The page you land on when a video is playing.')
parser.add_argument('-v','--version', action='version', version='PBSKIDS DL 3.0')
args = parser.parse_args()

response = urllib.request.urlopen(args.url)
webContent = response.read().decode('UTF-8')
soup = BeautifulSoup(webContent, features="lxml")
script = soup.find('script', type='application/json').text
data = json.loads(script)
assets = data['props']['pageProps']['videoData']['mediaManagerAsset']
vid_title = assets['title'].replace('/','+').replace('\\','+') + '.mp4'
print(vid_title)
videos = assets['videos']
for video in videos:
    if (video['profile'] == 'mp4-16x9-baseline'):
        realvid = video['url']
        print('Downloading Video...')
        print(realvid)
        urllib.request.urlretrieve(realvid, vid_title,handle_progress)
        break
print("\nThe operation completed.")
