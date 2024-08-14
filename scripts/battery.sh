#!/bin/bash

case "$BLOCK_BUTTON" in
    1) notify-send "battery1" ;;
    2) notify-send "battery2" ;;
    3) notify-send "battery3" ;;
    3) notify-send "battery4" ;;
    3) notify-send "battery5" ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#E94560^"

readarray -t output <<<"$(acpi battery)"
battery_count=${#output[@]}

for line in "${output[@]}"; do
    percentages+=("$(echo "$line" | grep -o -m1 '[0-9]\{1,3\}%' | tr -d '%')")
    statuses+=("$(echo "$line" | grep -E -o -m1 'Discharging|Charging|AC|Full|Unknown|Not charging')")
    remaining=$(echo "$line" | grep -E -o -m1 '[0-9][0-9]:[0-9][0-9]')
    if [[ -n $remaining ]]; then
        hours=$(echo "$remaining" | cut -d: -f1)
        if [ "$hours" -lt 20 ]; then
            remainings+=("$remaining")
        fi
    else
        remainings+=("")
    fi
done

text=""
max_index=$(($battery_count - 1))
for i in $(seq 0 $max_index); do

    if ((percentages[$i] > 0 && percentages[$i] < 25)); then
        color_fg="#E94560^"
    elif ((percentages[$i] >= 25 && percentages[$i] < 50)); then
        color_fg="#FE9B00^"
    elif ((percentages[$i] >= 50 && percentages[$i] < 75)); then
        color_fg="#F9FF69^"
    elif ((percentages[$i] >= 75)); then
        color_fg="#A7E36B^"
    fi

    case "${statuses[$i]}" in
        "Discharging")
            battery_icon="󱧥"
            battery_text="${percentages[$i]}% ${remainings[i]}"
            ;;
        "Unknown")
            battery_icon="󱠴"
            battery_text="${percentages[$i]}% ${remainings[i]}"
            ;;
        "Charging")
            battery_icon="󰂄"
            battery_text="${percentages[$i]}%"
            ;;
        "Full" | "AC" | "Not charging")
            battery_icon="󱟢"
            battery_text="${percentages[$i]}%"
            ;;
    esac

    # Print Battery number if there is more than one
    if (($max_index > 0)); then
        text="$text BAT$(($i + 1)):"
    fi

    text="$text $battery_icon $battery_text"
    # text="$text $battery_text $battery_icon"
done

color="$s2d_fg$color_fg$s2d_bg$color_bg"
printf "%s%s%s" "$color" "$text" "$s2d_reset"
