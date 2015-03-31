#################################################
# Gunicorn config for ogreserver
#################################################

bind = '127.0.0.1:{{ port }}'
import multiprocessing
workers = multiprocessing.cpu_count() * 2 + 1
backlog = 2048
worker_class = 'sync'
debug = True
daemon = False
timeout = 30
proc_name = 'gunicorn-inform'
pidfile = '/tmp/gunicorn-inform.pid'
errorlog = '-'
loglevel = 'error'
