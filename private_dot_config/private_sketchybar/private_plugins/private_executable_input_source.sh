#!/usr/bin/env bash

COLOR_BLUE=0xff57c7ff
COLOR_YELLOW=0xfff3f99d

VI_TELEX_ON=$(defaults read com.apple.HIToolbox AppleSelectedInputSources | grep -Po 'com.apple.inputmethod.VietnameseTelex')

if [[ -z $VI_TELEX_ON ]]; then
	ICON=' 󰬰'
	COLOR="$COLOR_YELLOW"
else
	ICON=' '
	COLOR="$COLOR_BLUE"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
