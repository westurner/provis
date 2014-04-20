#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
test_provis
----------------------------------

Tests for `provis` module.
"""

import unittest

from provis.net import (
    check_tcp_port, get_tcp_banner, ping, _parse_ping_output, PingSummary)


class TestProvisNet(unittest.TestCase):
    def test_parse_ping(self):
        io = [([
            '5 packets transmitted, 0 received, 100% packet loss, time 3999ms',
            'rtt min/avg/max/mdev = 0.039/0.044/0.052/0.008 ms'],
            PingSummary(5, 0, 100.0, 3999, 0.039, 0.044, 0.052, 0.008))]
        for i, o in io:
            output = _parse_ping_output(i)
            self.assertEqual(output, o)

    def test_ping(self):
        result = ping('127.0.0.1')
        self.assertTrue(result.avg)

    def test_check_tcp_port(self):
        output = check_tcp_port('127.0.0.1', 22)
        self.assertEqual(output, True)

    def test_get_tcp_banner(self):
        output = get_tcp_banner('127.0.0.1', 22)
        self.assertTrue(output.startswith('SSH'))
        self.assertIn('OpenSSH', output)


if __name__ == '__main__':
    unittest.main()
