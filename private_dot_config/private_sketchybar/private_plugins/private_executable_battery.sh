#!/usr/bin/env bash

# Caveat: BSD grep needs `-E` while GNU grep needs `-P`
PERCENTAGE="$(pmset -g batt | grep -Po "\d+%" 2>/dev/null | cut -d% -f1)"

COLOR_RED=0xffff5c57
COLOR_GREEN=0xff5af78e
COLOR_YELLOW=0xfff3f99d
COLOR_BLUE=0xff57c7ff

if [[ -z "$PERCENTAGE" ]]; then
	ICON=''
	COLOR=''
	LABEL='󱉞'
else
	CHARGING="$(pmset -g batt | grep 'AC Power')"

	if [[ ! -z "$CHARGING" ]]; then
		case "$PERCENTAGE" in
		9[8-9] | 100) ICON='󰂅' ;;
		9[0-7]) ICON='󰂋' ;;
		8[0-9]) ICON='󰂊' ;;
		7[0-9]) ICON='󰢞' ;;
		6[0-9]) ICON='󰂉' ;;
		5[0-9]) ICON='󰢝' ;;
		4[0-9]) ICON='󰂈' ;;
		3[0-9]) ICON='󰂇' ;;
		2[0-9]) ICON='󰂆' ;;
		1[0-9]) ICON='󰢜' ;;
		*) ICON='󰢟' ;;
		esac

		COLOR="$COLOR_GREEN"
	else
		case "$PERCENTAGE" in
		9[8-9] | 100) ICON='󰁹' COLOR="$COLOR_BLUE" ;;
		9[0-7]) ICON='󰂂' COLOR="$COLOR_BLUE" ;;
		8[0-9]) ICON='󰂁' COLOR="$COLOR_BLUE" ;;
		7[0-9]) ICON='󰂀' COLOR="$COLOR_YELLOW" ;;
		6[0-9]) ICON='󰂀' COLOR="$COLOR_YELLOW" ;;
		5[0-9]) ICON='󰁿' COLOR="$COLOR_YELLOW" ;;
		4[0-9]) ICON='󰁽' COLOR="$COLOR_YELLOW" ;;
		3[0-9]) ICON='󰁼' COLOR="$COLOR_RED" ;;
		2[0-9]) ICON='󰁻' COLOR="$COLOR_RED" ;;
		1[0-9]) ICON='󰁺' COLOR="$COLOR_RED" ;;
		*) ICON='󰂎' COLOR="$COLOR_RED" ;;
		esac
	fi

	LABEL="${PERCENTAGE}%"
fi

sketchybar --set "$NAME" \
	icon="$ICON" \
	icon.color="$COLOR" \
	icon.padding_right=4 \
	label="$LABEL" \
	label.color="$COLOR"
