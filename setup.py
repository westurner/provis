#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import sys
import codecs

VERSION = '0.1.1'

try:
    from setuptools import setup, Command
except ImportError:
    from distutils.core import setup, Command

if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist bdist_wheel')
    os.system('twine upload dist/*')
    sys.exit()

datadir = os.path.dirname(__file__)

def read_file(pth):
    with codecs.open(pth, 'r', 'utf8') as f:
        return f.read()


readme  = read_file(os.path.join(datadir, 'README.rst'))
history = read_file(os.path.join(datadir, 'HISTORY.rst'))


class PyTestCommand(Command):
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        import sys
        import subprocess
        errno = subprocess.call([sys.executable, 'runtests.py', '-v'])
        raise SystemExit(errno)

#data_files = [(path, [os.path.join(path, f) for f in files])
#    for dir, dirs, files in os.walk(datadir)]

#print(data_files)

setup(
    name='provis',
    version=VERSION,
    description=(
        'Infrastructure Provisioning Scripts, Configuration, and Tests'),
    long_description=readme + '\n\n' + history,
    author='Wes Turner',
    author_email='wes@wrd.nu',
    url='https://github.com/westurner/provis',
    packages=[
        'provis',
    ],
    package_dir={'provis': 'provis'},
    include_package_data=True,
    #data_files = data_files,
    install_requires=[
    ],
    license="BSD",
    zip_safe=False,
    keywords='provis',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        "Programming Language :: Python :: 2",
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
    ],
    test_suite='tests',
    tests_require=['pytest', 'pytest-capturelog'],
    cmdclass = {
        'test': PyTestCommand,
    },
)
