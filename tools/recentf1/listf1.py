#! /usr/bin/env python3

import json
import logging
import os
import signal
import time

import paho.mqtt.client as mqtt


TIME_SLEEP = 120

client = None

logger = logging.getLogger('recentf1')
logger.addHandler(logging.StreamHandler())
logger.setLevel(logging.INFO)

if os.environ.get('DEBUG'):
    logger.setLevel(logging.DEBUG)
    logger.debug('Debug logging enabled')


def hup_handler(signum, frame):  # pylint: disable=unused-argument
    'Trigger a publish on receive of HUP'
    logger.debug('HUP received, publishing F1 listing')
    publish()


def main():
    'Main program loop'

    # handle HUP signal sent to this script
    signal.signal(signal.SIGHUP, hup_handler)

    # setup MQTT client
    global client
    logger.debug('Connecting...')
    client = mqtt.Client('python_pub')
    client.connect('192.168.1.198', 1883)
    logger.debug('Connected')

    while True:
        publish()
        logger.debug('Sleeping..')
        time.sleep(TIME_SLEEP)
        logger.debug('Awake')


def publish():
    'Read the F1 directory and publish as JSON'

    output = {}

    for i, title in enumerate(sorted(os.listdir('/media'), reverse=True)[0:3]):
        if 'Qual' in title:
            f1type = 'Qualifying'
        elif 'Sprint' in title:
            f1type = 'Sprint'
        else:
            f1type = 'Race'

        output[f'f1_title_{i}'] = title[10:-14]
        output[f'f1_path_{i}'] = f'Extra/F1/{title}/02.{f1type}.Session.mp4'

    global client
    logger.debug('Publishing to homeassistant/sensor/jorg/f1')
    client.publish('homeassistant/sensor/jorg/f1', 3, retain=True)
    client.publish('homeassistant/sensor/jorg/f1/json', json.dumps(output), retain=True)

    logger.debug(json.dumps(output))


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
