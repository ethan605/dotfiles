#!/usr/bin/env bash

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

if [[ "$SENDER" = "volume_change" ]]; then
	case "$INFO" in
	[5-9][0-9] | 100) ICON='' LABEL="$INFO%" ;;
	[1-9] | [1-4][0-9]) ICON='' LABEL="$INFO%" ;;
	*) ICON='' LABEL='' ;;
	esac

	sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
fi
