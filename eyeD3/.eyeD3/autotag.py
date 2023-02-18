import copy
import datetime
import fnmatch
import os
import sys

from eyed3 import core, id3
from eyed3.plugins import load, LoaderPlugin
from eyed3.utils.console import getTtySize, printMsg, printError, printWarning


class AutotagPlugin(LoaderPlugin):
    SUMMARY = 'Automagically tag MP3s based on their filename and the parent folder name'
    DESCRIPTION = ""
    NAMES = ['autotag']

    def __init__(self, arg_parser):
        super().__init__(arg_parser)
        g = self.arg_group

        self.meta = None

        # CLI options
        g.add_argument('-f', '--force', action='store_true',
                       help=ARGS_HELP['--force'])
        g.add_argument('--compilation', action='store_true',
                       help=ARGS_HELP['--compilation'])
        g.add_argument('-G', '--genre',
                       help=ARGS_HELP['--genre'])
        g.add_argument('-E', '--eac',
                       help=ARGS_HELP['--eac'])
        g.add_argument('--skip-tests',
                       help=ARGS_HELP['--skip-tests'])
        g.add_argument('-v', '--verbose', action='store_true',
                       help=ARGS_HELP['--verbose'])

        # instantiate classic plugin with copy of args, so they don't clash
        # with ours, and resolve any conflicts that occur in argparse
        cloned_args = copy.copy(self.arg_group)
        cloned_args.conflict_handler = 'resolve'
        self.classic = load('classic')(cloned_args)


    def handleFile(self, f):
        super().handleFile(f)

        if len(self.args.paths) != 1:
            printError('Autotag operates on only a single album at a time')
            return

        # set album metadata once
        if self.meta is None:
            # ensure args is set in classic plugin
            self.classic.args = self.args

            # handle current directoty notation
            if self.args.paths[0] == '.':
                path = os.getcwd()
            else:
                path = self.args.paths[0]

            try:
                # extract album metadata from directory name
                self.parseDirectoryName(path)

            except AppException as e:
                printError(str(e))
                sys.exit(1)

        if not self.audio_file:
            if os.path.basename(f) != 'folder.jpg':
                printWarning('Unknown type: {}'.format(os.path.basename(f)))
        else:
            track_num, artist, title = self.smart_split(os.path.basename(f))
            self.tagFile(os.path.basename(f), track_num, artist, title)


    def smart_split(self, filename):
        """
        Extract title and track number from the filename:

         - normal albums are named "01 - Track Name"
         - compilations are named "01 - Artist Name - Track Name"
        """
        # handle dodgy dashes
        filename = filename.replace('–', '-')

        # split filename into parts
        parts = os.path.splitext(filename)[0].split(' - ')

        # split, find artists, albums, numbers, lowercase everything
        # validate all numbers?
        # rename files?

        track_num = artist = title = None

        if self.args.compilation:
            if len(parts) == 2:
                # Singles have no track number
                # handle "Artist - Title"
                track_num = 0
                artist = parts[0]
                title = parts[1]

            elif len(parts) == 3:
                # handle "TrackNum - Artist - Title"
                track_num = parts[0]
                artist = parts[1]
                title = parts[2]
        else:
            try:
                if len(parts) == 2:
                    # handle "TrackNum - Title"
                    track_num = parts[0]
                    artist = self.meta['artist']
                    title = parts[1]

                if len(parts) == 3:
                    if parts[0] == self.meta['artist']:
                        # handle "Artist - TrackNum - Title"
                        track_num = parts[1]
                        artist = self.meta['artist']
                        title = parts[2]
                    else:
                        # handle "TrackNum - Title1 - Title2"
                        track_num = parts[0]
                        artist = self.meta['artist']
                        title = ' - '.join(parts[1:])

            except ValueError as e:
                print(f'Probably failed to parse TrackNum: {e}')

        if None in (track_num, artist, title):
            print('')
            print('Failed to parse filename:')
            print(f'  {filename}')
            print('')
            print('Parseable filenames follow one of the following patterns:')
            print('')
            print('"TrackNum - Artist - Title"')
            print('"Artist - TrackNum - Title"')
            print('"TrackNum - Title"')
            print('"TrackNum - Title1 - Title2"')
            print('"Artist - Title" (only valid with --compilation)')
            sys.exit(1)

        return int(track_num), artist, title


    def tagFile(self, filename, track_num, artist, title):
        # TODO extract GENRE
        # if GENRE:
            # validate GENRE

        # force removal of existing tag
        if self.args.force is True and self.audio_file.tag is not None:
            id3.Tag.remove(self.audio_file.path, id3.ID3_ANY_VERSION)
            printMsg("Tag removed from '{}'".format(filename))

        # initialize
        if self.audio_file.tag is None:
            self.audio_file.initTag(id3.ID3_V2_4)

        # set the remainder of the tags
        self.audio_file.tag.track_num = track_num
        self.audio_file.tag.title = title
        self.audio_file.tag.artist = artist
        self.audio_file.tag.album_artist = self.meta['album_artist']
        self.audio_file.tag.album = self.meta['album']
        self.audio_file.tag.track_num = (track_num, self.meta['total_num_tracks'])
        self.audio_file.tag.recording_date = core.Date(self.meta['year'])
        self.audio_file.tag.tagging_date = '{:%Y-%m-%d}'.format(datetime.datetime.now())

        # set a tag to say this was ripped with EAC
        if self.args.eac is True:
            self.audio_file.tag.user_text_frames.set('EAC', 'Ripping Tool')

        # write a cover art image
        if self.meta['image'] is not None:
            self.audio_file.tag.images.set(
                type_=id3.frames.ImageFrame.FRONT_COVER,
                img_data=self.meta['image'],
                mime_type='image/jpeg',
            )

        # save the tag
        self.audio_file.tag.save(
            version=id3.ID3_V2_4,
            encoding='utf8',
            preserve_file_time=True,
        )

        # use classic plugin to print nice output
        self.classic.terminal_width = getTtySize()[1]
        self.classic.printHeader(self.audio_file.path)
        printMsg("-" * self.classic.terminal_width)
        self.classic.printAudioInfo(self.audio_file.info)
        self.classic.printTag(self.audio_file.tag)


    def parseDirectoryName(self, path):
        # verify directory name structure
        directory_name = os.path.basename(path)
        parts = directory_name.split(' - ')
        if len(parts) != 3:
            # check directory contains mp3s..
            if len(fnmatch.filter(os.listdir(path), '*.mp3')) == 0:
                raise AppException("No MP3s found in '{}'".format(directory_name))
            else:
                raise AppException("Badly formed directory name '{}'".format(directory_name))

        self.meta = {}
        self.meta['artist'] = parts[0]
        self.meta['year'] = int(parts[1])
        self.meta['album'] = parts[2]

        # in compilation mode, artist will vary per track
        self.meta['album_artist'] = self.meta['artist']

        # clean '(Disc *)' from album name; don't want it in ID3 tag
        if '(Disc' in self.meta['album']:
            self.meta['album'] = self.meta['album'][0:self.meta['album'].find('(Disc')-1]

        # count mp3's for track total
        self.meta['total_num_tracks'] = len(fnmatch.filter(os.listdir(path), '*.mp3'))

        self.meta['image'] = None
        if os.path.exists(os.path.join(path, 'folder.jpg')):
            # extract existing 'FRONT_COVER' image
            # check new/existing has largest height
            # set largest as folder.jpg
            with open(os.path.join(path, 'folder.jpg'), 'rb') as f:
                self.meta['image'] = f.read()

        # TODO load genre types / image types ?


ARGS_HELP = {
    '--force': 'Force removal of all existings tags.',
    '--compilation': 'Compilation album; sets TCMP frame, and expects each '
                     'track to contain artist name.',
    '--genre': 'Set the genre. If the argument is a standard ID3 genre '
               'name or number both will be set. Otherwise, any string '
               "can be used. Run 'eyeD3 --plugin=genres' for a list of "
               'standard ID3 genre names/ids.',
    '--eac': 'Set EAC as ripping tool in USER frame.',
    '--skip-tests': 'Skip eyeD3 test suite.',
    '--verbose': 'Show all available tag data',
}


class AppException(Exception):
    pass
