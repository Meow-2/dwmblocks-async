#!/bin/bash

case "$BLOCK_BUTTON" in
    # 1) notify-send "backlight1" ;;
    # 2) notify-send "backlight2" ;;
    # 3) notify-send "backlight3" ;;
    4)
        ~/.config/dwm/scripts/app-starter.sh set_backlight up 3 >/dev/null &
        exit 1
        ;;
    5)
        ~/.config/dwm/scripts/app-starter.sh set_backlight down 3 >/dev/null &
        exit 1
        ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#FFD371^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

backlight_icon="󰖨"
backlight_text=$(light | awk '{printf "%02d%", $1}') # light https://gitlab.com/dpeukert/light
text=" $backlight_icon $backlight_text "
# text="  $backlight_text $backlight_icon  "

printf "%s%s%s" "$color" "$text" "$s2d_reset"
