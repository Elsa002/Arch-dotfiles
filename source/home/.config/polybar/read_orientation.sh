#!/bin/bash

bash -c 'timeout 0.05 monitor-sensor | grep "=== Has accelerometer"' | grep -o ": .*)" | grep -o "[a-zA-Z-]*"
