#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
	HIGHLIGHT_STATUS=on
else
	HIGHLIGHT_STATUS=off
fi

sketchybar \
	--set "$NAME" \
	background.drawing="$HIGHLIGHT_STATUS" \
	icon.highlight="$HIGHLIGHT_STATUS" \
	label.highlight="$HIGHLIGHT_STATUS"
