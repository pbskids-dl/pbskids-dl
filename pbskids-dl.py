#!/usr/bin/env python3
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


import sys
pbskids_dl_version = '3.2'

def errorquit(exitmessage, exitcode, errorcode):
    print("ERROR: " + str(exitmessage), file=sys.stderr)
    print("Error code: " + str(errorcode), file=sys.stderr)
    print("Possible causes: Bad internet or script killed", file=sys.stderr)
    sys.exit(int(exitcode))

try:
    import argparse
    import urllib.request, urllib.error, urllib
    from bs4 import BeautifulSoup
    import json
except:
    errorquit("pbskids-dl needs these modules:\n\targparse, urllib (urllib3), and BeautifulSoup4 (bs4)", "128", "-1")

def handle_progress(chunk_number, chunk_size, total_size):
    length = 50
    
    total_chunk = total_size / chunk_size
    prefix = 'Downloading:'
    percent = ("{0:." + '1' + "f}").format(100 * (chunk_number / float(total_chunk)))
    filledLength = int(length * chunk_number // total_chunk)
    bar = '█' * filledLength + ' ' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}%', end = "\r", file=sys.stdout)
    if chunk_number == total_chunk: 
        print()

def cli_builder():
    parser = argparse.ArgumentParser(prog='pbskids-dl', description='A tool for downloading PBS KIDS videos.', epilog='Made by NexusSfan')
    parser.add_argument('url', help='The page you land on when a video is playing.')
    parser.add_argument('-f', '--filename', help='The file to store the video (optional).')
    parser.add_argument('-v', '--version', action='version', version='pbskids-dl '+pbskids_dl_version)
    parser.add_argument('-q', '--quiet', action='store_true')
    args = parser.parse_args()
    return args

def fetch_script(url):
    try:
        response = urllib.request.urlopen(url)
        webContent = response.read().decode('UTF-8')
        global soup
        soup = BeautifulSoup(webContent, features="lxml")
        script = soup.find('script', type='application/json').text
    except:
        nofoundurl = str('The \"' + url + '\" link failed to load properly. Is it a PBS KIDS Video link?')
        errorquit(nofoundurl, "128", "1")
    return script

def find_assets(script):
    try:
        data = json.loads(script)
        assets = data['props']['pageProps']['videoData']['mediaManagerAsset']
        videos = assets['videos']
    except:
        errorquit("ERROR: The video was not found! Is the link a PBS KIDS Video link?", "128", "2")
    return assets,videos

def check_drm():
    global soup
    isdrm = soup.find('\"drm_enabled\"\:true')
    if str(isdrm) != "None":
        errorquit("DRM Content is not available in pbskids-dl...", "1", "4")

def download_video(vid_title, video, isquiet, filename):
    try:
        global realvid
        realvid = video['url']
        print('Downloading Video...')
        print(realvid)
        if filename != '':
            vid_title = filename
        if isquiet:
            urllib.request.urlretrieve(realvid, vid_title)
        else:
            urllib.request.urlretrieve(realvid, vid_title, handle_progress)
    except:
        errorquit("The video cannot be downloaded! Script was probably killed.", "128", "3")

def main():
    args = cli_builder()
    script = fetch_script(args.url)
    check_drm()
    assets, videos = find_assets(script)
    vid_title = assets['title'].replace('/','+').replace('\\','+') + '.mp4'
    if args.filename:
        print(args.filename)
    else:
        print(vid_title)
    for video in videos:
        if (video['profile'] == 'mp4-16x9-baseline'):
            download_video(vid_title, video, args.quiet, args.filename)
            print("\nThe download succeded.")
            return
    print("\nDownload failed.")
    sys.exit(1)

if __name__ == "__main__":
    main()
    sys.exit(0)
