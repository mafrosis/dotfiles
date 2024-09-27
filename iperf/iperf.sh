#!/bin/bash

SERVER=${1:-jorg}
iperf3 -c $SERVER -P4 -t30 -i5 -R | awk '/.*SUM.*sender/ {print $6" "$7}'

