#!/usr/bin/env bash

COLOR_RED=0xffff5c57
COLOR_BLUE=0xff57c7ff
COLOR_YELLOW=0xfff3f99d

if mpc status '%state%' >/dev/null 2>&1; then
	SONG="$(mpc current -f '%title%')"
	POS="$(mpc status '%songpos%/%length%')"
	EXTRA=''

	if [[ $(mpc status '%random%') == 'on' ]]; then
		EXTRA+='󰒟'
	fi

	if [[ $(mpc status '%repeat%') == 'on' ]]; then
		if [[ $(mpc status '%single%') == 'on' ]]; then
			EXTRA+='󰑘'
		else
			EXTRA+='󰑖'
		fi
	fi

	if [[ -z "$EXTRA" ]]; then
		LABEL=" $POS  •  $SONG"
	else
		LABEL=" $POS  •  $SONG  •  $EXTRA"
	fi

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
