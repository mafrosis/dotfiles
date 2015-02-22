from __future__ import absolute_import
from __future__ import division

import datetime
import os
import StringIO

import dropbox

from .exceptions import CouldntConnectError, FileExistsError
from .utils import format_size, format_time, format_bitrate, retry


def upload(prntr, api_key, source_filepath, dest_path, force=False):
    if dest_path is not None:
        dest_filepath = '{}/{}'.format(dest_path, os.path.basename(source_filepath))
    else:
        dest_filepath = '{}'.format(os.path.basename(source_filepath))

    prntr.p('Uploading {} to Dropbox at /{}'.format(source_filepath, dest_path))

    client = connect(api_key)

    if force is False and check_file_exists(client, dest_filepath) is True:
        raise FileExistsError(dest_filepath)

    filesize = os.path.getsize(source_filepath)
    prntr.p('Filesize: {}'.format(format_size(filesize)))

    upload_id = None
    bytes_uploaded = 0
    i = 0
    CHUNK=4194304

    # init the progress bar
    prntr.progressf(num_blocks=0, total_size=filesize, extra=' - starting - ')

    while bytes_uploaded < filesize:
        bytes_uploaded, upload_id = upload_chunk(
            client,
            source_filepath,
            upload_id,
            offset=bytes_uploaded,
            chunk_size=CHUNK
        )
        i += 1

        # calculate time remaining
        elapsed = (datetime.datetime.now() - prntr.start).seconds
        upload_rate = bytes_uploaded / elapsed
        time_remaining = int((filesize - bytes_uploaded) / upload_rate)

        # display progress bar
        prntr.progressf(
            num_blocks=i, block_size=CHUNK, total_size=filesize,
            extra=' {}  {} - {} remaining  '.format(
                format_size(bytes_uploaded),
                format_bitrate(upload_rate),
                format_time(time_remaining)
            )
        )

    ret = upload_commit(client, dest_filepath, upload_id, overwrite=force)
    prntr.p('Wrote {} bytes to {}'.format(ret['bytes'], ret['path']))
    prntr.close()


def connect(api_key):
    client = dropbox.client.DropboxClient(api_key)

    try:
        client.account_info()
    except dropbox.rest.ErrorResponse as e:
        raise CouldntConnectError('Unable to connect to Dropbox!', inner_excp=e)

    return client


@retry(times=3)
def upload_chunk(client, path, upload_id=None, offset=0, chunk_size=4194304):
    with open(path, 'rb') as f:
        f.seek(offset)
        return client.upload_chunk(
            StringIO.StringIO(f.read(chunk_size)),
            offset=offset,
            upload_id=upload_id
        )


def upload_commit(client, path, upload_id, overwrite=False):
    ret = client.commit_chunked_upload(
        path,
        upload_id,
        autorename=False
    )

    # commit_chunked_upload fails to move the file to its destination
    # so follow up with a move API call

    if check_file_exists(client, path) is True:
        # if destination exists, abort and delete uploaded file
        if overwrite is True:
            client.file_delete(path)
        else:
            client.file_delete(ret['path'][1:])
            raise FileExistsError(path)

    # move the uploaded file
    client.file_move(ret['path'][1:], path)
    return ret


def check_file_exists(client, path):
    try:
        # check destination file exists
        ret = client.metadata(path)
        if ret.get('is_deleted', False):
            return False
        else:
            return True
    except dropbox.rest.ErrorResponse:
        return False
