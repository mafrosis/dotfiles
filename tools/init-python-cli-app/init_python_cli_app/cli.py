from __future__ import absolute_import
from __future__ import unicode_literals

import argparse
import sys

from . import __version__
from .core import process_template


class AppException(Exception):
    pass


def entrypoint():
    try:
        # setup and run argparse
        args = parse_command_line()

        # run main
        main(args)

    except AppException as e:
        sys.stderr.write('{}\n'.format(e))
        sys.stderr.flush()
        sys.exit(1)


def parse_command_line():
    parser = argparse.ArgumentParser(
        description='init-python-cli-app'
    )

    # print the current version
    parser.add_argument(
        '-v', '--version', action='version',
        version='init-python-cli-app {}'.format(__version__),
        help='Print the current init-python-cli-app version')

    parser.add_argument(
        'project_name',
        help='The name of the CLI project to setup')
    parser.add_argument(
        '--verbose', action='store_true',
        help='Verbose print during template processing')
    parser.add_argument(
        '--clear', action='store_true',
        help='Delete destination directory if it exists')

    return parser.parse_args()


def main(args):
    process_template(args.project_name, args.verbose, args.clear)
