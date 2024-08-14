#!/bin/bash

case "$BLOCK_BUTTON" in
    1) notify-send "mem1" ;;
    2) notify-send "mem2" ;;
    3) notify-send "mem3" ;;
    4) notify-send "mem4" ;;
    5) notify-send "mem5" ;;
esac

s2d_reset="^d^" # statu2d control
s2d_fg="^c"
s2d_bg="^b"

color_bg="#16213E^"
color_fg="#C7F2A4^"
color="$s2d_fg$color_fg$s2d_bg$color_bg"

mem_text=$(awk '
/^MemTotal:/ {
	mem_total=$2
}
/^MemAvailable:/ {
	mem_available=$2
}
END {
	available=mem_available/1024/1024
	used=(mem_total-mem_available)/1024/1024
	total=mem_total/1024/1024

	pct=0
	if (total > 0) {
		pct=used/total*100
	}

	# full text
    printf("%02dG/%02dG(%02d%%)\n", used, total, pct)
}
' /proc/meminfo)

mem_icon=""
text=" $mem_icon $mem_text"
# text="  $mem_text $mem_icon  "
printf "%s%s%s" "$color" "$text" "$s2d_reset"
