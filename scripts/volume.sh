#!/bin/bash

vol_change_step=4
case "$BLOCK_BUTTON" in
    1) pactl set-sink-mute @DEFAULT_SINK@ toggle </dev/null >/dev/null 2>&1 ;;
    2) pavucontrol </dev/null >/dev/null 2>&1 & ;;
    3)
        if playerctl -a status | grep -q "Paused" && ! playerctl -a status | grep -q "Playing"; then
            playerctl -a play </dev/null >/dev/null 2>&1 &
            isPaused="no"
        else
            playerctl -a pause </dev/null >/dev/null 2>&1 &
            isPaused="yes"
        fi
        ;;
    4) # vol_up
        current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | rg -o ' [0-9]+% ' | sed 's/%[[:space:]]//g' | head -n1)
        if [ $((current_volume + vol_change_step)) -gt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ 100% </dev/null >/dev/null 2>&1
        else
            pactl set-sink-volume @DEFAULT_SINK@ +${vol_change_step}% </dev/null >/dev/null 2>&1
        fi
        mpv --no-video ~/.config/dwm/dwmblocks-async/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
        ;;
    5) # vol_down
        pactl set-sink-volume @DEFAULT_SINK@ -${vol_change_step}% </dev/null >/dev/null 2>&1
        mpv --no-video ~/.config/dwm/dwmblocks-async/assets/audio-volume-change.oga </dev/null >/dev/null 2>&1 &
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
    vol_text="MT"
    vol_icon="󰖁"
elif [ "$vol_text" -eq 0 ]; then
    vol_text="00"
    vol_icon="󰖁"
elif [ "$vol_text" -lt 10 ]; then
    vol_icon="󰕿"
    vol_text=0$vol_text
elif [ "$vol_text" -le 20 ]; then
    vol_icon="󰕿"
elif [ "$vol_text" -le 60 ]; then
    vol_icon="󰖀"
else vol_icon="󰕾"; fi

if [ -n "$isPaused" ]; then
    if [ "$isPaused" = "yes" ]; then
        vol_icon="󰏤"
    fi
elif playerctl -a status | grep -q "Paused" && ! playerctl -a status | grep -q "Playing"; then
    vol_icon="󰏤"
fi

vol_text=${vol_text}%

text=" $vol_icon $vol_text"
printf "%s%s%s" "$color" "$text" "$s2d_reset"
