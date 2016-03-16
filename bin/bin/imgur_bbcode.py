#! /usr/bin/env python

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

# extract album URLs
urls = [next(next(d.children))[0]['src'][0:-5] for d in soup.select('div.post')]

# print bbcode
bbcodes = ['[url=http://{0}.jpg][img]http://{0}b.jpg[/img][/url]'.format(u[2:]) for u in urls]
print ''.join(bbcodes)
