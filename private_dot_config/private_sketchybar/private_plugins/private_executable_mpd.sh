#!/usr/bin/env bash

COLOR_RED=0xffff5c57
COLOR_BLUE=0xff57c7ff
COLOR_YELLOW=0xfff3f99d
COLOR_WHITE=0xffeff0eb

if mpc status '%state%' >/dev/null 2>&1; then
	STATUS=''

	if [[ $(mpc status '%random%') == 'on' ]]; then
		STATUS+='󰒟'
	fi

	if [[ $(mpc status '%repeat%') == 'on' ]]; then
		if [[ $(mpc status '%single%') == 'on' ]]; then
			STATUS+='󰑘'
		else
			STATUS+='󰑖'
		fi
	fi

	SONG="$(mpc current -f '%title%')"
	POS="$(mpc status '%songpos%/%length%')"
	LABEL="$STATUS  •  $SONG  •  $POS"
	LABEL_COLOR="$COLOR_WHITE"

	case "$(mpc status '%state%')" in
	playing) ICON='󰝚' ICON_COLOR="$COLOR_BLUE" ;;
	paused) ICON='' ICON_COLOR="$COLOR_YELLOW" ;;

	*)
		ICON=''
		LABEL='󰝛'
		LABEL_COLOR="$COLOR_RED"
		;;
	esac
else
	ICON=''
	LABEL='󰝛'
	LABEL_COLOR="$COLOR_RED"
fi

sketchybar --set "$NAME" \
	icon="$ICON" icon.color="$ICON_COLOR" \
	label="$LABEL" label.color="$LABEL_COLOR"
