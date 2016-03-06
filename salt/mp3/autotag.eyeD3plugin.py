import copy
import datetime
import fnmatch
import os
import sys

import eyed3
from eyed3 import core, id3
from eyed3 import LOCAL_ENCODING
from eyed3.plugins import load, LoaderPlugin
from eyed3.utils.console import printMsg, printError, printWarning

eyed3.require((0, 7))

class AutotagPlugin(LoaderPlugin):
    SUMMARY = u'Automagically tag MP3s based on their filename and the parent folder name'
    DESCRIPTION = u"""
Description here
"""
    NAMES = ['autotag']

    def __init__(self, arg_parser):
        super(AutotagPlugin, self).__init__(arg_parser)
        g = self.arg_group

        self.meta = None

        def UnicodeArg(arg):
            return unicode(arg, LOCAL_ENCODING)

        # CLI options
        g.add_argument('-f', '--force', action='store_true',
                       help=ARGS_HELP['--force'])
        g.add_argument('--compilation', action='store_true',
                       help=ARGS_HELP['--compilation'])
        g.add_argument('-G', '--genre', type=UnicodeArg,
                       help=ARGS_HELP['--genre'])
        g.add_argument('-E', '--eac', type=UnicodeArg,
                       help=ARGS_HELP['--eac'])
        g.add_argument('--skip-tests', type=UnicodeArg,
                       help=ARGS_HELP['--skip-tests'])
        g.add_argument('-v', '--verbose', action='store_true',
                       help=ARGS_HELP['--verbose'])

        # instantiate classic plugin with copy of args, so they don't clash
        # with ours, and resolve any conflicts that occur in argparse
        cloned_args = copy.copy(self.arg_group)
        cloned_args.conflict_handler = 'resolve'
        self.classic = load('classic')(cloned_args)


    def handleFile(self, f):
        super(AutotagPlugin, self).handleFile(f)

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
            self.tagFile(os.path.basename(f))


    def tagFile(self, filename):
        # get the filesystem character encoding
        fs_encoding = sys.getfilesystemencoding()
        
        parts = os.path.splitext(filename)[0].split(' - ')

        if self.args.compilation:
            # compilations are named "01i - Artist Name - Track Name"
            track_num = parts[0]
            artist = parts[1]
            title = parts[2]
        else:
            # normal albums are named "01 - Track Name"
            track_num = parts[0]
            artist = self.meta['artist']
            title = parts[1]

        # extract GENRE
        # if GENRE:
            # validate GENRE

        # force removal of existing tag
        if self.args.force is True and self.audio_file.tag is not None:
            id3.Tag.remove(self.audio_file.path, id3.ID3_ANY_VERSION)
            printMsg("Tag removed from '{}'".format(filename))

        # initialize 
        if self.audio_file.tag is None:
            self.audio_file.initTag(id3.ID3_V2_4)

        # decode from filesystem encoding where necessary
        if type(artist) is str:
            self.audio_file.tag.artist = artist.decode(fs_encoding)
        else:
            self.audio_file.tag.artist = artist

        if type(self.meta['album_artist']) is str:
            self.audio_file.tag.album_artist = self.meta['album_artist'].decode(fs_encoding)
        else:
            self.audio_file.tag.album_artist = self.meta['album_artist']

        if type(self.meta['album']) is str:
            self.audio_file.tag.album = self.meta['album'].decode(fs_encoding)
        else:
            self.audio_file.tag.album = self.meta['album']

        # set the remainder of the tags
        self.audio_file.tag.title = title
        self.audio_file.tag.track_num = (track_num, self.meta['total_num_tracks'])
        self.audio_file.tag.recording_date = core.Date(self.meta['year'])
        self.audio_file.tag.tagging_date = '{:%Y-%m-%d}'.format(datetime.datetime.now())

        # set a tag to say this was ripped with EAC
        if self.args.eac is True:
            self.audio_file.tag.user_text_frames.set(u'EAC', u'Ripping Tool')

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

        # print output from the classic plugin
        self.classic.printHeader(self.audio_file.path)
        printMsg("-" * 79)
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
