#!/usr/bin/env python3
pbskids_dl_version = '3.0'

def errorquit(exitmessage, exitcode, errorcode):
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
    parser.add_argument('-v', '--version', action='version', version='PBSKIDS DL '+pbskids_dl_version)
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
        nofoundurl = str('The \"' + url + '\" link failed to load properly. Is it a PBS Kids Video link?')
        errorquit(nofoundurl, "128", "1")
    return script

def find_assets(script):
    try:
        data = json.loads(script)
        assets = data['props']['pageProps']['videoData']['mediaManagerAsset']
        videos = assets['videos']
    except:
        errorquit("ERROR: The video was not found! Is the link a PBS Kids Video link?", "128", "2")
    return assets,videos

def check_drm():
    global soup
    isdrm = soup.find('\"drm_enabled\"\:true')
    if str(isdrm) != "None":
        errorquit("DRM Content is not available in pbskids-dl... yet", "1", "4")

def download_video(vid_title, video):
    try:
        global realvid
        realvid = video['url']
        print('Downloading Video...')
        print(realvid)
        urllib.request.urlretrieve(realvid, vid_title, handle_progress)
    except:
        errorquit("The video cannot be downloaded! Script was probably killed.", "128", "3")

def main():
    args = cli_builder()
    script = fetch_script(args.url)
    check_drm()
    assets, videos = find_assets(script)
    vid_title = assets['title'].replace('/','+').replace('\\','+') + '.mp4'
    print(vid_title)
    for video in videos:
        if (video['profile'] == 'mp4-16x9-baseline'):
            download_video(vid_title, video)
            break
    print("\nThe operation completed.")

if __name__ == "__main__":
    main()
    sys.exit(0)
