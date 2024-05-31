#!/usr/bin/env python3

def errorquit(exitmessage, exitcode, errorcode)
    print("ERROR: " + str(exitmessage), file=sys.stderr)
    print("Error code: " + str(errorcode), file=sys.stderr)
    print("Possible causes: Bad internet or script killed", file=sys.stderr)
    sys.exit(int(exitcode))

try:
    import sys
    import argparse
    import urllib.request, urllib.error, urllib
    from bs4 import BeautifulSoup
    import json
except:
    errorquit("pbskids-dl needs these modules:\n\targparse, urllib, BeautifulSoup4 (bs4)\, and json", "0", "128")

def handle_progress(chunk_number, chunk_size, total_size):
    total_chunk = total_size / chunk_size
    length = 50
    decimals = 1
    prefix = 'Downloading:'
    suffix = ''
    percent = ("{0:." + str(decimals) + "f}").format(100 * (chunk_number / float(total_chunk)))
    filledLength = int(length * chunk_number // total_chunk)
    bar = '█' * filledLength + ' ' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}', end = "\r", file=sys.stdout)
    if chunk_number == total_chunk: 
        print()

#End pbskids-dl init

parser = argparse.ArgumentParser(prog='pbskids-dl', description='A tool for downloading PBS KIDS videos.', epilog='Made by NexusSfan')
parser.add_argument('url', help='The page you land on when a video is playing.')
parser.add_argument('-v','--version', action='version', version='PBSKIDS DL 3.0')
args = parser.parse_args()

try:
    response = urllib.request.urlopen(args.url)
    webContent = response.read().decode('UTF-8')
    soup = BeautifulSoup(webContent, features="lxml")
    script = soup.find('script', type='application/json').text
except:
    nofoundurl = str('ERROR: The \"' + args.url + '\" link failed to load properly. Is it a PBS Kids Video link?')
    errorquit(nofoundurl, "1", "128")

isdrm = soup.find('\"drm_enabled\"\:true')
if str(isdrm) != "None":
    errorquit("DRM Content is not available in pbskids-dl... yet", "4", "1")

try:
    data = json.loads(script)
    assets = data['props']['pageProps']['videoData']['mediaManagerAsset']
    videos = assets['videos']
except:
    errorquit("ERROR: The video was not found! Is the link a PBS Kids Video link?", "2", "128"

vid_title = assets['title'].replace('/','+').replace('\\','+') + '.mp4'
print(vid_title)
for video in videos:
    if (video['profile'] == 'mp4-16x9-baseline'):
        try:
            realvid = video['url']
            print('Downloading Video...')
            print(realvid)
            urllib.request.urlretrieve(realvid, vid_title, handle_progress)
        except:
            errorquit("ERROR: The video cannot be downloaded! Script was probably killed.", "3", "128")
        break
print("\nThe operation completed.")
sys.exit(0)
