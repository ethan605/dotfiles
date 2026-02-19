#!/usr/bin/env bash

if mpc status '%state%' >/dev/null 2>&1; then
	song=$(mpc current -f '%title%')
	pos=$(mpc status '%currenttime%/%totaltime%')
	label="$song  •  $pos"

	case "$(mpc status '%state%')" in
	playing) icon="󰝚" ;;
	paused) icon="" ;;
	*) label="" icon="󰝛" ;;
	esac
else
	label=""
  icon="󰝛"
fi

sketchybar --set "$NAME" icon="${icon}" label="${label}"
