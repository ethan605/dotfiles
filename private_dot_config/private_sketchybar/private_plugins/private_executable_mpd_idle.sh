#!/usr/bin/env bash

while true; do
  /run/current-system/sw/bin/mpc idle
  /run/current-system/sw/bin/sketchybar --trigger mpd_idle
done
