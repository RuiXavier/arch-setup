#!/bin/bash

# Create a cache directory for image previews
TMP_DIR="$HOME/.cache/cliphist"
mkdir -p "$TMP_DIR"

# 1. Read the cliphist list and format it for Rofi
# FIX: Inject a clickable "Clear History" entry at the top of the menu!
list="󰃢 Clear Clipboard History\n"
list+=$(cliphist list | while IFS= read -r line; do
    id=$(echo "$line" | grep -oE '^[0-9]+')
    content=$(echo "$line" | cut -f2-)
    
    # Ignore the annoying Wayland 'h' ghost entries
    if [ "$content" = "h" ]; then
        continue
    fi
    
    # Image previews
    if [[ "$content" == *"[[ binary data"* ]]; then
        img_path="$TMP_DIR/$id.png"
        if [ ! -f "$img_path" ]; then
            # FIX: cliphist needs the FULL line, not just the ID, to decode the image
            echo "$line" | cliphist decode > "$img_path" 2>/dev/null
        fi
        echo -en "${line}\x00icon\x1f${img_path}\n"
    else
        echo -en "${line}\n"
    fi
done)

# 2. Feed it into Rofi 
chosen=$(echo -en "$list" | rofi -dmenu -i -p "󰅌 " \
    -show-icons \
    -kb-custom-1 "Alt+c" \
    -theme-str '
        window { width: 600px; } 
        listview { lines: 8; } 
        element-icon { size: 40px; }
        
        /* Removed the fake textbox-clear, keeping the inputbar clean */
        inputbar { 
            children: [ prompt, entry ]; 
        }
        
        prompt {
            vertical-align: 0.5;
            font: "JetBrainsMono Nerd Font 14";
            margin: 0px 10px 0px 0px;
        }
        
        entry {
            vertical-align: 0.5;
            placeholder: "Search clipboard...";
        }
    ')

# 3. Capture Rofi's exit code
exit_code=$?

# 4. Handle the user's action
if [ $exit_code -eq 10 ] || [ "$chosen" = "󰃢 Clear Clipboard History" ]; then
    # The user pressed Alt+C OR clicked our new clear entry
    cliphist wipe
    rm -rf "$TMP_DIR"/*
    notify-send -a "Clipboard" -i "edit-clear-all" "History Cleared" "Your clipboard is now empty."
elif [ $exit_code -eq 0 ] && [ -n "$chosen" ]; then
    # FIX: Pass the ENTIRE $chosen line into cliphist decode
    printf "%s\n" "$chosen" | cliphist decode | wl-copy
fi