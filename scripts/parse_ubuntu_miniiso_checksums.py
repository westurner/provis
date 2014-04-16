#!/usr/bin/env python
from __future__ import print_function
__doc__ = '''
parse_ubuntu_miniiso_checksums.py:
    Scrape Ubuntu MinimalCD HTML for structured data and generate:
    * miniiso-MD5SUMS
    * miniiso-SHA1SUMs (partial)
    * download commands with sensible filenames (to stdout)

'''

import collections
import re
import bs4


ISO = collections.namedtuple('ISO',
    'version codename shortcodename arch size md5 sha1 url filename')

def iso_str(self):
    def _iso_str(self):
        for key, value in self._asdict().items():
            yield u"#  %s: %s" % (key, value)
    return u'\n'.join(_iso_str(self))
ISO.__str__ = ISO.__unicode__ = iso_str


MINIMAL_CD_URL = "https://help.ubuntu.com/community/Installation/MinimalCD"

uri_rgx = re.compile(
    r'.*/installer-([\w\d]+).*')

uri_rgx_ppc = re.compile(
    r'.*/images/([\w\d]+)/netboot/.*')


def parse_arch_from_url(url):
    if '/installer-powerpc/' in url:
        return uri_rgx_ppc.match(url).group(1)
    else:
        return uri_rgx.match(url).group(1)
    raise Exception(url)


shellescape_rgx = re.compile(
    '[\w\d/:\.]+')

def shellescape(value):
    if not shellescape_rgx.match(value):
        raise Exception("Shell escape failed")
    return value


def extract_isos_from_html(content):
    bs = bs4.BeautifulSoup(content)
    iso_links = bs.find_all('a', {'href': lambda x: x.endswith('mini.iso')})
    rgx = re.compile(
        (r'Ubuntu (\d+\.\d+) "([\w\s]+)" '
        'Minimal CD\s+([\d\.]+MB)\*? \((.*)\).*'))

    for link in iso_links:
        url = link.get('href')
        arch = parse_arch_from_url(url)
        text = link.parent.text
        (version,
         codename,
         size,
         _checksums) = rgx.match(text).groups()
        shortcodename = codename.split()[0].lower()
        obj = {
            'version': version,
            'codename': codename,
            'shortcodename': shortcodename,
            'arch': arch,
            'size': size,
            'md5': None,
            'sha1': None,
            'url': shellescape(link.get('href')),
            'filename': None
        }
        obj['filename'] = 'ubuntu-{version}-minimal-{arch}.iso'.format(**obj)
        _checksums = _checksums.split(',')
        for checksum in _checksums:
            algo, value = checksum.split(':')
            algo = algo.strip()
            value = shellescape(value.strip())
            obj[algo.lower()] = value

        yield ISO(**obj)


def write_checksum_file(objs, attr, filename):
    with open(filename, 'w') as f:
        for obj in objs:
            value = getattr(obj, attr)
            if value:
                f.write(u'%s *%s' % (value, obj.filename))
                f.write('\n')


def read_file(filepath):
    if filepath.startswith('http'):
        try:
            import requests
            resp = requests.get(filepath)
            content = resp.content
        except ImportError:
            import urllib2
            resp = urllib2.urlopen(filepath)
            content = resp.read()
    else:
        with open(filepath,'r') as f:
            content = f.read()
    return content


def parse_ubuntu_miniiso_checksums(fileuri,
        cmdstr="wget -c '{url}' -O '{filename}'" ):
    isos = extract_isos_from_html(read_file(fileuri))
    isos = tuple(isos)
    print("")
    print("## WARNING: Review these command strings for OS command injection")
    print("")
    for iso in isos:
        print(cmdstr.format(**iso._asdict()))
        print(iso)
        cmd = ('wget', '-c', iso.url, '-O', iso.filename); cmd

    write_checksum_file(isos, 'md5', 'miniiso-MD5SUMS')
    write_checksum_file(isos, 'sha1', 'miniiso-SHA1SUMS')
    #write_checksum_file(isos, 'sha256', 'SHA256SUMS')


def main(*args):
    import argparse

    prs = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    prs.add_argument('fileuri', help='HTTP URL or file path to MinimalCD HTML',
                     action='store',
                     default=MINIMAL_CD_URL,
                     nargs='?')
    opts = prs.parse_args()

    parse_ubuntu_miniiso_checksums(opts.fileuri)


if __name__ == "__main__":
    main()
