#!/bin/bash

backlight_change_step=5
case "$BLOCK_BUTTON" in
    4) # backlight up
        light -A $backlight_change_step </dev/null >/dev/null 2>&1 ;;
    5) # backlight down
        light -U $backlight_change_step </dev/null >/dev/null 2>&1 ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#FFD371^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

backlight_icon="󰖨"
backlight_text=$(light | awk '{printf "%02d%", $1}') # light https://gitlab.com/dpeukert/light
text=" $backlight_icon $backlight_text"
# text="  $backlight_text $backlight_icon  "

printf "%s%s%s" "$color" "$text" "$s2d_reset"

# current_backlight=$(ddcutil getvcp 10 | grep -i 'Brightness' | awk '{print $9}' | sed 's/,$//')
# up) /usr/bin/ddcutil setvcp 10 $((current_backlight + "${step}")) && kill -39 "$(pidof dwmblocks)"
# down) /usr/bin/ddcutil setvcp 10 $((current_backlight - "${step}")) && kill -39 "$(pidof dwmblocks)"
# up) /usr/bin/xbacklight "+${step}" && kill -39 "$(pidof dwmblocks)" ;;
# down) /usr/bin/xbacklight "-${step}" && kill -39 "$(pidof dwmblocks)" ;;
