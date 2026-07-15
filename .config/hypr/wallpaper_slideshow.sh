#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
INTERVAL=300 # 5 minutes

# Loop forever
while true; do
    # SLEEP FIRST! 
    # This ensures that when the script is (re)started, it waits 5 minutes 
    # before it touches your background.
    sleep $INTERVAL

    # Find, shuffle, and pick
    NEXT_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg \) | shuf -n 1)

    # Apply
    if [ -n "$NEXT_WALL" ]; then
        swww img "$NEXT_WALL" \
            --transition-fps 60 \
            --transition-type wipe \
            --transition-angle 30 \
            --transition-duration 1.5
    fi
done