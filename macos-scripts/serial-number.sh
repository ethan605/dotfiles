#! /usr/bin/env bash

system_profiler SPHardwareDataType | awk -F': ' '/Serial Number/ { print $2 }'
