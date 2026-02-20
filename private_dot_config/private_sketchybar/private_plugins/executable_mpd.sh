#!/usr/bin/env bash

if mpc status '%state%' >/dev/null 2>&1; then
	SONG=$(mpc current -f '%title%')
	POSITION=$(mpc status '%currenttime%/%totaltime%')
	LABEL="$SONG  •  $POSITION"

	case "$(mpc status '%state%')" in
	playing) ICON="󰝚" ;;
	paused) ICON="" ;;

	*)
		LABEL=""
		ICON="󰝛"
		;;
	esac
else
	LABEL=""
	ICON="󰝛"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
