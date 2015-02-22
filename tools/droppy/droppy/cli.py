from __future__ import absolute_import
from __future__ import unicode_literals

import argparse
import os
import sys

from . import __version__
from .config import load_config
from .core import upload
from .exceptions import AppException
from .printer import CliPrinter


def entrypoint():
    try:
        # setup and run argparse
        args = parse_command_line()

        prntr = CliPrinter(debug=args.debug)

        # load application config (API key)
        conf = load_config()

        # run main
        main(prntr, conf, args)

    except AppException as e:
        prntr.e(str(e), excp=e)
        prntr.close()
        sys.exit(1)


def parse_command_line():
    parser = argparse.ArgumentParser(
        description='droppy'
    )
    subparsers = parser.add_subparsers()

    # print the current version
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument(
        '-v', '--version', action='version',
        version='droppy {}'.format(__version__),
        help='Print the current droppy version')

    parent_parser.add_argument(
        '-d', '--debug', action='store_true',
        help='Display debug via exception stack traces')

    # setup parser for put command
    pput = subparsers.add_parser('put',
        parents=[parent_parser],
        help='Upload a file to Dropbox',
    )
    pput.set_defaults(mode='put')

    pput.add_argument(
        '-f', '--force', action='store_true',
        help='Force overwrite files at the destination')

    pput.add_argument(
        'source_filepath',
        help='Source file to upload')
    pput.add_argument(
        'dest_path', nargs='?', default=None,
        help='Destination directory on Dropbox (defaults to the root)')

    args = parser.parse_args()

    if not os.path.exists(args.source_filepath):
        parser.error('Supplied path is not a file!')

    return args


def main(prntr, conf, args):
    if args.mode == 'put':
        upload(
            prntr,
            conf['DROPBOX_KEY'],
            args.source_filepath,
            args.dest_path,
            force=args.force
        )
