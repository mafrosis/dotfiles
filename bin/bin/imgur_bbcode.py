#! /usr/bin/env python

from __future__ import print_function

import bs4
import requests
import sys

if len(sys.argv) == 1:
    sys.stderr.write('You must pass an Imgur URL\n')
    sys.exit(1)
else:
    url = sys.argv[1]
    if not url.endswith('/all'):
        url += '/all'

# load URL
data = requests.get(url)
soup = bs4.BeautifulSoup(data.text, 'html.parser')

# extract images from album
imgs = [img.attrs['id'] for img in soup.select('div.post-image-container')]

# print bbcode
bbcodes = ['[url=http://i.imgur.com/{0}.jpg][img]http://i.imgur.com/{0}b.jpg[/img][/url]'.format(u) for u in imgs]
print(''.join(bbcodes))
