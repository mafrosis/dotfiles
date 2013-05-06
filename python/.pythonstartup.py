AP_AUTOCOMPLETE=False
import sys
try:
    import readline
except ImportError:
    print "Module readline unavailable"
else:
    import rlcompleter
    readline.parse_and_bind("tab: complete")
    if sys.platform == 'darwin':
        readline.parse_and_bind("bind ^I rl_complete")
    AP_AUTOCOMPLETE=True
