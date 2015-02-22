from __future__ import absolute_import

from .printer import CoreException


class AppException(CoreException):
    pass

class CouldntConnectError(AppException):
    pass

class FileExistsError(AppException):
    def __init__(self, msg):
        super(FileExistsError, self).__init__('File already exists at {}'.format(msg))
