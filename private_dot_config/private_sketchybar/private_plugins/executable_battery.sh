#!/usr/bin/env bash

# Caveat: BSD grep needs `-E` while GNU grep needs `-P`
PERCENTAGE="$(pmset -g batt | grep -Po "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [[ -z "$PERCENTAGE" ]]; then
	exit 0
fi

if [[ ! -z "$CHARGING" ]]; then
	case "$PERCENTAGE" in
	9[8-9] | 100) ICON="󰂅" ;;
	9[0-7]) ICON="󰂋" ;;
	8[0-9]) ICON="󰂊" ;;
	7[0-9]) ICON="󰢞" ;;
	6[0-9]) ICON="󰂉" ;;
	5[0-9]) ICON="󰢝" ;;
	4[0-9]) ICON="󰂈" ;;
	3[0-9]) ICON="󰂇" ;;
	2[0-9]) ICON="󰂆" ;;
	1[0-9]) ICON="󰢜" ;;
	*) ICON="󰢟" ;;
	esac
else
	case "$PERCENTAGE" in
	9[8-9] | 100) ICON="󰁹" ;;
	9[0-7]) ICON="󰂂" ;;
	8[0-9]) ICON="󰂁" ;;
	7[0-9]) ICON="󰂀" ;;
	6[0-9]) ICON="󰂀" ;;
	5[0-9]) ICON="󰁿" ;;
	4[0-9]) ICON="󰁽" ;;
	3[0-9]) ICON="󰁼" ;;
	2[0-9]) ICON="󰁻" ;;
	1[0-9]) ICON="󰁺" ;;
	*) ICON="󰂎" ;;
	esac
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
