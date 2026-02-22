#!/usr/bin/env bash

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

COLOR_RED=0xffff5c57
COLOR_WHITE=0xffeff0eb

if [[ "$SENDER" = "volume_change" ]]; then
  COLOR="$COLOR_WHITE"

	case "$INFO" in
	[5-9][0-9] | 100) ICON='' LABEL="$INFO%" ;;
	[1-9] | [1-4][0-9]) ICON='' LABEL="$INFO%" ;;
	*) ICON='' LABEL='' COLOR="$COLOR_RED" ;;
	esac

	sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" label.color="$COLOR"
fi
