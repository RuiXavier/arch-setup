#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"

# Check if directory exists and has files
if [ ! -d "$WALL_DIR" ] || [ -z "$(ls -A "$WALL_DIR")" ]; then
    rofi -e "No wallpapers found in $WALL_DIR"
    exit 1
fi

# Build the list of files for rofi
file_list=""
for file in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    # Skip if glob doesn't match anything
    [ -e "$file" ] || continue
    
    # Get just the filename
    filename=$(basename "$file")
    
    # Append to the list: "Filename\0icon\x1f/path/to/image\n"
    file_list+="${filename}\x00icon\x1f${file}\n"
done

# Feed the list to rofi
selected=$(echo -en "$file_list" | rofi -dmenu -i -p "󰸉 Wallpapers" \
    -show-icons \
    -theme-str '
        window { width: 50%; } 
        listview { columns: 4; lines: 2; spacing: 15px; } 
        element { orientation: vertical; padding: 10px; border-radius: 16px; } 
        element-icon { size: 150px; border-radius: 12px; } 
        element-text { horizontal-align: 0.5; }
    ')

# If the user selected a wallpaper (didn't hit Escape)
if [ -n "$selected" ]; then
    # 1. Apply it with a center-grow animation
    swww img "$WALL_DIR/$selected" \
        --transition-fps 60 \
        --transition-type grow \
        --transition-pos 0.5,0.5 \
        --transition-duration 1.0

    # 2. Reset the background timer
    # Kill any existing slideshows quietly
    killall wallpaper_slideshow.sh 2>/dev/null 
    
    # Spawn a fresh slideshow process in the background. 
    # Because of our edit above, it will immediately go to sleep for 5 minutes!
    ~/.config/hypr/wallpaper_slideshow.sh &
fi