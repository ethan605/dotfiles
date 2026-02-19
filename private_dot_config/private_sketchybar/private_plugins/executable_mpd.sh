#!/usr/bin/env bash

if mpc status '%state%' >/dev/null 2>&1; then
	song=$(mpc current -f '%title%')
	status=$(mpc status '%state%')
	pos=$(mpc status '%currenttime%/%totaltime%')
	output="$song  •  $pos"

	case "$status" in
	playing) icon="󰝚" ;;
	paused) icon="" ;;
	*) output="" icon="󰝛" ;;
	esac

else
	output=""
  icon="󰝛"
fi

sketchybar -m --set mpd icon="${icon}" --set mpd label="${output}"
