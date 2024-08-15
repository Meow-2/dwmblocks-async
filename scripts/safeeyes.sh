#!/bin/bash

case "$BLOCK_BUTTON" in
    1)
        if safeeyes --status | grep -q "暂停"; then
            safeeyes -e </dev/null >/dev/null 2>&1 &
            isPaused="no"
            dunstify "Safeeyes 已开启" </dev/null >/dev/null 2>&1 &
        else
            safeeyes -d </dev/null >/dev/null 2>&1 &
            isPaused="yes"
            dunstify "Safeeyes 已暂停" </dev/null >/dev/null 2>&1 &
        fi
        ;;
    2)
        safeeyes -s </dev/null >/dev/null 2>&1 &
        ;;
    3)
        dunstify "$(safeeyes --status)" </dev/null >/dev/null 2>&1 &
        ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#A7E36B^"

safe_icon="󱫑"

if [ "$isPaused" = "yes" ]; then
    safe_icon="󱫟"
    color_fg="#E94560^"
elif [ "$isPaused" = "no" ]; then
    color_fg="#A7E36B^"
    safe_icon="󱫑"
elif safeeyes --status | grep -q "暂停"; then
    safe_icon="󱫟"
    color_fg="#E94560^"
fi

text=" $safe_icon "
color="$s2d_fg$color_fg$s2d_bg$color_bg"
printf "%s%s%s" "$color" "$text" "$s2d_reset"
