#!/usr/bin/env bash

COLOR_RED=0xffff5c57
COLOR_BLUE=0xff57c7ff

VI_TELEX_ON=$(defaults read com.apple.HIToolbox AppleSelectedInputSources | grep -Po 'com.apple.inputmethod.VietnameseTelex')

if [[ -z $VI_TELEX_ON ]]; then
	ICON=' 󰬰'
	COLOR="$COLOR_BLUE"
else
	ICON=' '
	COLOR="$COLOR_RED"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
