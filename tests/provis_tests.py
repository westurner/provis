#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
test_provis
----------------------------------

Tests for `provis` module.
"""

import unittest
import requests
from urlobject import URLObject

from provis.net import (
    check_tcp_port, get_tcp_banner, ping)


class ServerTest(unittest.TestCase):
    def setUp(self):
        self.IP = NotImplemented
        self.hostname = NotImplemented


class Ping(object):
    def test_0_ping(self):
        pingsummary = ping(self.IP)
        self.assertTrue(pingsummary.avg)
        self.assertLess(pingsummary.loss, 100)


class SSH(object):
    def test_0_tcp_22(self):
        self.assertTrue(check_tcp_port(self.IP, 22))

    def test_1_banner_22(self):
        banner = get_tcp_banner(self.IP, 22)
        self.assertIn("SSH", banner)
        self.assertIn("OpenSSH", banner)


class HTTP(object):
    @property
    def url(self):
        return URLObject().with_netloc(self.IP)

    def test_0_tcp_80(self):
        self.assertTrue(check_tcp_port(self.IP, 80))

    def test_1_http(self):
        url = self.url.with_scheme('http')
        resp = requests.get(url)
        self.assertEqual(resp.status_code, 200)


class NginxHTTP(HTTP):
    def test_1_http(self):
        url = self.url.with_scheme('http')
        resp = requests.get(url)
        self.assertEqual(resp.status_code, 200)
        self.assertIn('server', resp.headers)
        self.assertTrue(resp.headers['server'].startswith('nginx/'))


class HTTPS(object):
    def test_0_tcp_443(self):
        self.assertTrue(check_tcp_port(self.IP, 443))

    def test_1_https(self):
        url = self.url.with_scheme('https')
        resp = requests.get(url)
        self.assertEqual(resp.status_code, 200)


###

class TestRod(ServerTest, Ping, SSH, NginxHTTP):
    def setUp(self):
        self.IP = "10.1.4.232"
        self.hostname = "rod"


# class TestSalt(ServerTest, SSH):
#     def setUp(self):
#         self.IP = "internal ip"
#         self.hostname = "salt"


if __name__ == '__main__':
    unittest.main()
