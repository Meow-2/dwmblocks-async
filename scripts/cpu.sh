#!/usr/bin/env bash

case "$BLOCK_BUTTON" in
    1) dunstify "cpu1" ;;
    2) dunstify "cpu2" ;;
    3) dunstify "cpu3" ;;
    4) dunstify "cpu4" ;;
    5) dunstify "cpu5" ;;
    6) dunstify "cpu6" ;;
    7) dunstify "cpu7" ;;
    8) dunstify "cpu8" ;;
    9) dunstify "cpu9" ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#B6E388^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

cpu_icon="󰒇"
cpu_text="$(top -bn1 | awk '/^%Cpu/ { usage=int($2 + $4) } END { printf("%02d",usage) }')%"
text=" $cpu_icon $cpu_text"
# text="  $cpu_text $cpu_icon  "
printf "%s%s%s" "$color" "$text" "$s2d_reset"
