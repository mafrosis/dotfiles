#! /usr/bin/env python3

import json
import os

output = {}

for i, f1 in enumerate(sorted(os.listdir("/media/pools/video/F1"), reverse=True)[0:3]):
    output[f'f1_title_{i}'] = f1
    output[f'f1_path_{i}'] = "Extra/F1/{}/02.{}.Session.mp4".format(f1, "Qualifying" if "Qual" in f1 else "Race")

print(json.dumps(output))
