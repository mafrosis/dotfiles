# -*- coding: utf-8 -*-
'''
Caskroom for Homebrew on Mac OS X
'''

# Import python libs
import logging

# Import salt libs
import salt.utils

log = logging.getLogger(__name__)


def __virtual__():
    '''
    Confine this module to Mac OS with Homebrew.
    '''
    if salt.utils.which('brew') and __grains__['os'] == 'MacOS':
        return 'caskroom'
    return False


def _homebrew_bin():
    '''
    Returns the full path to the homebrew binary in the PATH
    '''
    ret = __salt__['cmd.run']('brew --prefix', output_loglevel='trace')
    ret += '/bin/brew'
    return ret


def installed(name):
    #_homebrew_bin = __salt__['brew._homebrew_bin']()
    user = __salt__['file.get_user'](_homebrew_bin())

    if __salt__['cmd.retcode']('brew cask', runas=user) > 0:
        import pdb;pdb.set_trace()
        # TODO install cask
        pass

    return __salt__['brew.install']('cask {}'.format(name))


def latest(name):
    # if brew.upgrade_availeable (name)
    #    brew.upgrade (name)
    pass
