#!/usr/bin/env bash

COLOR_RED=0xffff5c57
COLOR_BLUE=0xff57c7ff
COLOR_YELLOW=0xfff3f99d

if mpc status '%state%' >/dev/null 2>&1; then
	SONG="$(mpc current -f '%title%')"
	POSITION="$(mpc status '%currenttime%/%totaltime%')"
	LABEL="$SONG  •  $POSITION"

	case "$(mpc status '%state%')" in
	playing) ICON='󰝚' COLOR="$COLOR_BLUE" ;;
	paused) ICON='' COLOR="$COLOR_YELLOW" ;;

	*)
		ICON='󰝛'
		COLOR="$COLOR_RED"
		LABEL=''
		;;
	esac
else
	ICON='󰝛'
	COLOR="$COLOR_RED"
	LABEL=''
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
