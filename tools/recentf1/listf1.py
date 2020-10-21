#! /usr/bin/env python3

import json
import os
import time

import paho.mqtt.client as mqtt

TIME_SLEEP = 120


def main():
    # setup MQTT client and LWT topic
    client = mqtt.Client('python_pub')
    client.connect('ringil', 1883)

    output = {}

    while True:
        for i, f1 in enumerate(sorted(os.listdir("/media"), reverse=True)[0:3]):
            output[f'f1_title_{i}'] = f1
            output[f'f1_path_{i}'] = "Extra/F1/{}/02.{}.Session.mp4".format(f1, "Qualifying" if "Qual" in f1 else "Race")

        print(json.dumps(output))

        client.publish('sensor/jorg/f1', len(output))
        client.publish('sensor/jorg/f1/json', json.dumps(output))

        time.sleep(TIME_SLEEP)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        pass
