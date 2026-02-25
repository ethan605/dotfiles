#!/usr/bin/env bash

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

COLOR_RED=0xffff5c57
COLOR_WHITE=0xffeff0eb

AUDIO_SOURCE="$(SwitchAudioSource -c -fjson -toutput | jq -r '.uid' | tr '[:upper:]' '[:lower:]')"

if [[ $AUDIO_SOURCE == 'builtinspeakerdevice' ]]; then
	AUDIO='󰓃'
else
	AUDIO='󰋋'
fi

if [[ "$SENDER" = "volume_change" ]]; then
	COLOR="$COLOR_WHITE"

	case "$INFO" in
	[5-9][0-9] | 100) ICON='' LABEL="$INFO% $AUDIO" ;;
	[1-9] | [1-4][0-9]) ICON='' LABEL="$INFO% $AUDIO" ;;
	*) ICON='' LABEL="$AUDIO" COLOR="$COLOR_RED" ;;
	esac

	sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" label.color="$COLOR"
fi
