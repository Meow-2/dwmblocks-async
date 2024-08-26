#!/usr/bin/env bash

case "$BLOCK_BUTTON" in
    1) notify-send "date1" ;;
    2) notify-send "date2" ;;
    3) notify-send "date3" ;;
    4) notify-send "date4" ;;
    5) notify-send "date5" ;;
esac
s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#DFF6FF^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

time_text="$(date '+%m/%d %H:%M')"
case "$(date '+%I')" in
    "01") time_icon="" ;;
    "02") time_icon="" ;;
    "03") time_icon="" ;;
    "04") time_icon="" ;;
    "05") time_icon="" ;;
    "06") time_icon="" ;;
    "07") time_icon="" ;;
    "08") time_icon="" ;;
    "09") time_icon="" ;;
    "10") time_icon="" ;;
    "11") time_icon="" ;;
    "12") time_icon="" ;;
esac

text=" $time_icon $time_text"
# text="  $time_text $time_icon  "
printf "%s%s%s" "$color" "$text" "$s2d_reset"
