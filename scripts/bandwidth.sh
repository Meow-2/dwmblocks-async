#!/bin/bash

get_network_name(){
    INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')
    if [ -z "$INTERFACE" ]|| ! [ -e "/sys/class/net/${INTERFACE}/operstate" ] \
        || { ! [ "$TREAT_UNKNOWN_AS_UP" = "1" ] \
            && ! [ "$(cat /sys/class/net/"${INTERFACE}"/operstate)" = "up" ] ;}; then
        network_name="无网络连接"
    else
        network_name=$(nmcli | grep -m1 "$INTERFACE")
    fi
    dunstify "${network_name}"
}

get_network_ip(){
    INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')
    if [ -z "$INTERFACE" ]|| ! [ -e "/sys/class/net/${INTERFACE}/operstate" ] \
        || { ! [ "$TREAT_UNKNOWN_AS_UP" = "1" ] \
            && ! [ "$(cat /sys/class/net/"${INTERFACE}"/operstate)" = "up" ] ;}; then
        all_ip="无网络连接"
    else
        all_ip=$(ip -o -4 addr show | awk '{print $2, $4}'| sed "/$INTERFACE/s/\$/  /")
    fi
    dunstify "${all_ip}"
}
case "$BLOCK_BUTTON" in
    1) get_network_name & 
       exit 1;;
    2) nm-connection-editor >/dev/null & 
       exit 1;;
    3) get_network_ip & 
       exit 1;;
    # 4) notify-send "4" ;;
    # 5) notify-send "5" ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"
color_bg="#16213E^"
color_fg="#FCFFB2^"
# cpu_icon="󰒇"
# text=" $cpu_icon $cpu_text "
# printf "%s%s%s" "$color" "$text" "$s2d_reset"

bandwidth_icon_in=""
bandwidth_icon_out=""

# Use the provided interface, otherwise the device used for the default route.
INTERFACE=$(ip route | awk '/^default/ { print $5 ; exit }')

# Exit if there is no default route
if [[ -z "$INTERFACE" ]];then
    color_fg="#E94560^"
    color="$s2d_fg$color_fg$s2d_bg$color_bg"
    text=" 󰪎 No NetWork "
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
    exit 0
fi

# Issue #36 compliant.
if ! [ -e "/sys/class/net/${INTERFACE}/operstate" ] \
    || { ! [ "$TREAT_UNKNOWN_AS_UP" = "1" ] \
        && ! [ "$(cat /sys/class/net/"${INTERFACE}"/operstate)" = "up" ] ;}; then
    color_fg="#E94560^"
    color="$s2d_fg$color_fg$s2d_bg$color_bg"
    text=" $INTERFACE down "
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
    exit 0
fi

# path to store the old results in
path="/tmp/$(basename "$0")-${INTERFACE}"

# grabbing data for each adapter.
read -r rx <"/sys/class/net/${INTERFACE}/statistics/rx_bytes"
read -r tx <"/sys/class/net/${INTERFACE}/statistics/tx_bytes"

# get time
time="$(date +%s)"

# write current data if file does not exist. Do not exit, this will cause
# problems if this file is sourced instead of executed as another process.
if ! [[ -f "${path}" ]]; then
    echo "${time} ${rx} ${tx}" >"${path}"
    chmod 0666 "${path}"
fi

# read previous state and update data storage
read -r old <"${path}"
echo "${time} ${rx} ${tx}" >"${path}"

# parse old data and calc time passed
old=(${old//;/ })
time_diff=$((time - old[0]))

# sanity check: has a positive amount of time passed
[[ "${time_diff}" -gt 0 ]] || exit

# calc bytes transferred, and their rate in byte/s
rx_diff=$((rx - old[1]))
tx_diff=$((tx - old[2]))
rx_rate=$((rx_diff / time_diff))
tx_rate=$((tx_diff / time_diff))

# shift by 10 bytes to get KiB/s. If the value is larger than
# 1024^2 = 1048576, then display MiB/s instead

# incoming
rx_kib=$((rx_rate >> 10))
if hash bc 2>/dev/null && [[ "$rx_kib" -ge 1000 ]]; then
    if [[ "$rx_kib" -ge 10240 ]]; then
        bandwidth_text_in="$(echo "scale=1; $rx_kib / 1024" | bc | awk '{printf "%2d󰉁M/s", int($1)}')"
    else
        bandwidth_text_in="$(echo "scale=1; $rx_kib / 1024" | bc | awk '{printf "%3sM/s", $1}')"
    fi
else
    bandwidth_text_in="$(echo $rx_kib | awk '{printf "%3sK/s", $1}')"
fi

# outgoing
tx_kib=$((tx_rate >> 10))
if hash bc 2>/dev/null && [[ "$tx_kib" -ge 1000 ]]; then
    if [[ "$tx_kib" -ge 10240 ]]; then
        bandwidth_text_out="$(echo "scale=1; $tx_kib / 1024" | bc | awk '{printf "%2d󰉁M/s", int($1)}')"
    else
        bandwidth_text_out="$(echo "scale=1; $tx_kib / 1024" | bc | awk '{printf "%3sM/s", $1}')"
    fi
else
    bandwidth_text_out="$(echo $tx_kib | awk '{printf "%3sK/s", $1}')"
fi

# text=" $bandwidth_icon_in $bandwidth_text_in  $bandwidth_icon_out $bandwidth_text_out "
text=" $bandwidth_icon_in $bandwidth_text_in "
# text=" $bandwidth_text_in $bandwidth_icon_in $bandwidth_text_out $bandwidth_icon_out "
color="$s2d_fg$color_fg$s2d_bg$color_bg"
printf "%s%s%s" "$color" "$text" "$s2d_reset"
