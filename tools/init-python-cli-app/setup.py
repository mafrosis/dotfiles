#! /usr/bin/env python

import os
import sys

import init_python_cli_app

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    sys.exit()

packages = [
    'init_python_cli_app',
]

requires = [
    open('requirements.txt').read()
]

if sys.version_info < (2, 7):
    requires += ['argparse']

setup(
    name='init-python-cli-app',
    version=init_python_cli_app.__version__,
    description='',
    long_description=open('README.rst').read(),
    author='Matt Black',
    author_email='dev@mafro.net',
    url='http://github.com/mafrosis/init-python-cli-app',
    packages=packages,
    package_data={'': ['LICENSE']},
    package_dir={'': '.'},
    include_package_data=True,
    install_requires=requires,
    entry_points = {
        'console_scripts': ['init-python-cli-app=init_python_cli_app.cli:entrypoint']
    },
    license=open('LICENSE').read(),
    classifiers=(
        'Development Status :: 3 - Alpha',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'Intended Audience :: System Administrators',
        'Natural Language :: English',
        'License :: OSI Approved :: BSD License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
    ),
)
