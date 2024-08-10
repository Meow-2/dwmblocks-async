#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER ""

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
// update
#define BLOCKS(X)                                                          \
    X("","~/.config/dwm/dwmblocks-async/scripts/arch_update.sh 2>/dev/null", 1800 , 8) \
    X("","~/.config/dwm/dwmblocks-async/scripts/bandwidth.sh 2>/dev/null"  , 2    , 1) \
    X("","~/.config/dwm/dwmblocks-async/scripts/cpu.sh 2>/dev/null"        , 2    , 2) \
    X("","~/.config/dwm/dwmblocks-async/scripts/memory.sh 2>/dev/null"     , 2    , 3) \
    X("","~/.config/dwm/dwmblocks-async/scripts/time.sh 2>/dev/null"       , 25   , 4) \
    X("","~/.config/dwm/dwmblocks-async/scripts/backlight.sh 2>/dev/null"  , 30   , 5) \
    X("","~/.config/dwm/dwmblocks-async/scripts/volume.sh 2>/dev/null"     , 1    , 6) \
    X("","~/.config/dwm/dwmblocks-async/scripts/battery.sh 2>/dev/null"    , 60   , 7) \
    // update_volume_at_once: kill -40 $(pidof dwmblocks);
    // why 40? 40=34+6=SIGRTMIN+6,SIGRTMIN+n is real time singal

#endif  // CONFIG_Hxsetroot -name
