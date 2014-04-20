#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
provis.net
==========
Network utilities for testing provisioned infrastructure
"""
import re
import socket
from collections import namedtuple
from io import TextIOWrapper
import sarge
from structlog import get_logger
log = get_logger()


def check_tcp_port(host, port, timeout=5):
    """
    Check that a TCP port is connect-able

    Args:
        host (str): hostname or IP
        port (int): port number
        timeout (int): socket timeout in seconds

    Returns:
        bool: Whether ``socket.connext_ex`` succeeded

    """
    log.bind(host=host, port=port, timeout=timeout)
    log.debug("check_tcp_port")
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        result = s.connect_ex((host, port))
        return result == 0
    except:
        raise
    finally:
        s.close()


def get_tcp_banner(host, port, timeout=5, length=80, send=r"\000\n"):
    """
    Retrieve the first few characters sent after a TCP connect

    Args:
        host (str): hostname or IP
        port (int): port number
        timeout (int): socket timeout in seconds
        length (int): number of bytes to read
        send (str): bytes to send

    Returns:
        str: response text of at most ``length`` bytes

    """
    log.bind(host=host, port=port, timeout=timeout, length=80)
    log.debug("get_tcp_banner")
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(timeout)
        s.connect((host, port))
        sent = s.send(send)
        if sent == 0:
            raise Exception("socket connection broken")
        banner = s.recv(length)
        return banner
    except:
        raise
    finally:
        s.close()


PingSummary = namedtuple('PingSummary',
                         'tx rx loss time min avg max mdev')


def _parse_ping_output(output):
    """
    Parse the first matching summary line from ``ping``

    Args:
        output (TODO): output from ``ping``

    Return:
        :py:class:`PingSummary`: tx, rx, loss%, time in ms
    """
    tx, rx, loss, time = None, None, None, None
    min_, avg, max_, mdev = None, None, None, None

    ping_summary_rgx = re.compile(
        r'(\d+) packets transmitted, (\d+) received, '
        '([\d]+)% packet loss, time ([\d]+)ms\n?')
    ping_rtt_summary_rgx = re.compile(
        r'rtt min/avg/max/mdev = '
        '([\d\.]+)/([\d\.]+)/([\d\.]+)/([\d\.]+) ms\n?')

    for line in output:
        summary_match = ping_summary_rgx.match(line)
        if summary_match:
            tx, rx, loss, time = summary_match.groups()
            tx = int(tx)
            rx = int(rx)
            loss = float(loss)
            time = int(time)
        if tx:
            rtt_summary_match = ping_rtt_summary_rgx.match(line)
            if rtt_summary_match:
                min_, avg, max_, mdev = map(float, rtt_summary_match.groups())
    return PingSummary(tx, rx, loss, time, min_, avg, max_, mdev)


def ping(host, count=5, deadline=5):
    """
    ICMP ECHO ping a host (with ``ping``)

    Args:
        host (str): hostname or IP
        count (int): number of packets to send (``-c``)
        deadline (int): timeout in seconds (``-w``)

    Returns:
        :py:class:`PingSummary`: parsed ping summary
    """
    cmd = sarge.shell_format(
        """ping -q -c {0} -w {1} -i 0.2 {2}""",
        count,
        deadline,
        host)
    p = sarge.capture_stdout(cmd)
    return _parse_ping_output(TextIOWrapper(p.stdout))
