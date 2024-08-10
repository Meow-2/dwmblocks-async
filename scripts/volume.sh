#!/bin/bash

case "$BLOCK_BUTTON" in
    1) ~/.config/dwm/scripts/app-starter.sh set_vol toggle ;;
    2) echo 1 ;;
    3)
        pavucontrol >/dev/null &
        exit 1
        ;;
    4)
        ~/.config/dwm/scripts/app-starter.sh set_vol up 3 >/dev/null &
        exit 1
        ;;
    5)
        ~/.config/dwm/scripts/app-starter.sh set_vol down 3 >/dev/null &
        exit 1
        ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#FEB139^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

vol_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep "是")
vol_text=$(pactl get-sink-volume @DEFAULT_SINK@ | rg -o ' [0-9]+% ' | sed 's/[ %]//g' | head -n1)

if [ "$vol_muted" ]; then
    vol_text="--"
    vol_icon="󰖁"
elif [ "$vol_text" -eq 0 ]; then
    vol_icon="󰖁"
elif [ "$vol_text" -lt 10 ]; then
    vol_icon="󰕿"
    vol_text=0$vol_text
elif [ "$vol_text" -le 20 ]; then
    vol_icon="󰕿"
elif [ "$vol_text" -le 60 ]; then
    vol_icon="󰖀"
else vol_icon="󰕾"; fi

vol_text=${vol_text}%

text=" $vol_icon $vol_text "
printf "%s%s%s" "$color" "$text" "$s2d_reset"
