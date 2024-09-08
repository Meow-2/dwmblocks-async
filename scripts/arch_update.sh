#!/usr/bin/env bash

case "$BLOCK_BUTTON" in
    1)
        kitty -o initial_window_width=1920 -o initial_window_height=1080 -o remember_window_size=no --class=floatkitty --hold zsh -c "paru -Syu --noconfirm;kill -42 \$(pidof dwmblocks)" >/dev/null &
        exit 1
        ;;
    2)
        microsoft-edge-dev 'https://archive.archlinux.org/' >/dev/null &
        exit 1
        ;;
    3)
        microsoft-edge-dev 'https://aur.archlinux.org/packages?O=0&K=' >/dev/null &
        exit 1
        ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#DFF6FF^"

INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')
while [[ -z $INTERFACE ]] \
    || ! [ -e "/sys/class/net/${INTERFACE}/operstate" ] \
    || (! [ "$TREAT_UNKNOWN_AS_UP" = "1" ] \
        && ! [ "$(cat /sys/class/net/${INTERFACE}/operstate)" = "up" ]); do
    # color_fg="#E94560^"
    # color="$s2d_fg$color_fg$s2d_bg$color_bg"
    # text="  󱡦  "
    # printf "%s%s%s" "$color" "$text" "$s2d_reset"
    #
    # reactivate() {
    #     kill -42 $(pidof dwmblocks)
    # }
    # trap reactivate EXIT
    # exit 0
    INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')
done

updates=()

pacman_output=$(checkupdates 2>/dev/null)
if [[ -n "$pacman_output" ]]; then
    while IFS= read -r line; do
        updates+=("${line%% *}")
    done <<<"$pacman_output"
fi

paru_out=$(paru -Qu 2>/dev/null)
if [[ -n "$paru_out" ]]; then
    while IFS= read -r line; do
        if ! echo "$line" | grep -q -e "已忽略"; then
            updates+=("${line%% *}")
        fi
    done <<<"$paru_out"
fi

if [[ ${#updates[@]} -eq 0 ]]; then
    text="   "
else
    text="  󰚰 "
    color_fg="#FFD371^"
fi

color="$s2d_fg$color_fg$s2d_bg$color_bg"

printf "%s%s%s" "$color" "$text" "$s2d_reset"
