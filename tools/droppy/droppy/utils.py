from __future__ import absolute_import
from __future__ import unicode_literals

import datetime
import functools
import math


def retry(times):
    def decorator(f):
        @functools.wraps(f)
        def wrapped(*args, **kwargs):
            """
            Retry method N number of times.

            - Expects Exception to indicate called method failure.
            - The most recent Exception is re-raised if no success.
            """
            retry = 0

            while retry < times:
                last_error = None
                try:
                    ret = f(*args, **kwargs)
                    break
                except Exception as e:
                    last_error = e
                retry += 1

            if last_error is not None:
                raise last_error

            return ret

        return wrapped
    return decorator


def format_size(size):
   size_name = ('B', 'KB', 'MB', 'GB', 'TB', 'PB')

   i = int(math.floor(math.log(size, 1024)))
   s = round(size / math.pow(1024, i), 2)

   if s > 0:
       return '{}{}'.format(s, size_name[i])
   else:
       return '0B'


def format_time(delta):
    if type(delta) is datetime.timedelta:
        delta = delta.seconds
    hours, rem = divmod(delta, 3600)
    mins, secs = divmod(rem, 60)
    return '{:0>2d}:{:0>2d}:{:0>2d}'.format(hours, mins, secs)


def format_bitrate(n):
    if n > 0:
        n = n / 1000
    return '{0:.2f}kB/s'.format(n)
