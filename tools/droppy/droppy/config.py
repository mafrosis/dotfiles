import json
import os

from . import __title__

CONFIG = {
    'DROPBOX_KEY': 'Enter your Dropbox API key:',
}


def _get_or_init_config():
    config_dir = os.path.join(
        os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config')), __title__
    )

    # use existing config if available
    if os.path.exists(config_dir) and os.path.exists(os.path.join(config_dir, 'app.config')):
        with open(os.path.join(config_dir, 'app.config'), 'r') as f_config:
            conf = json.loads(f_config.read())
    else:
        # initialize application config
        conf = {}
        if os.path.exists(config_dir) is False:
            os.makedirs(config_dir)

    return conf, config_dir


def _write_config(conf, config_dir):
    # write the config file
    with open(os.path.join(config_dir, 'app.config'), 'w') as f_config:
        f_config.write(json.dumps(conf))


def load_config():
    conf, config_dir = _get_or_init_config()
    write = False
    for key, msg in CONFIG.iteritems():
        if not key in conf:
            print msg
            conf[key] = raw_input()
            write = True
    if write:
        _write_config(conf, config_dir)
        print '{} deploy config written to {}'.format(__title__, config_dir)
    return conf


def dump_config():
    conf, config_dir = _get_or_init_config()
    if conf:
        for key in CONFIG:
            print '{}:\t\t{}'.format(key, conf[key])
    else:
        print 'Not yet configured!'
