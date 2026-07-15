#!/bin/bash

# Options with high-res Nerd Font icons
perf="󰓅  Performance"
bal="󰗎  Balanced"
save="󰌪  Power Saver"

options="$perf\n$bal\n$save"

# Launch Rofi with fixed dimensions and Mocha styling
chosen=$(echo -e "$options" | rofi -dmenu -theme-str '
    window {
        location: northeast;
        anchor: northeast;
        x-offset: -15px;
        y-offset: 65px;
        width: 250px; /* Increased width to prevent text clipping */
        border-radius: 16px;
        background-color: #1e1e2e; /* Catppuccin Mocha Base */
        border: 2px; 
        border-color: #cba6f7; /* Catppuccin Mauve */
        padding: 8px;
    }
    mainbox { 
        background-color: transparent;
        children: [ listview ]; 
    }
    listview { 
        lines: 3; 
        columns: 1;
        spacing: 4px; 
        cycle: true;
        dynamic: true;
        layout: vertical;
        background-color: transparent;
    }
    element { 
        padding: 12px; 
        border-radius: 10px; 
        background-color: transparent;
        text-color: #cdd6f4; /* Catppuccin Text */
    }
    element-text {
        font: "JetBrainsMono Nerd Font 13"; /* Slightly larger, crisp font */
        background-color: transparent;
        text-color: inherit;
        vertical-align: 0.5;
    }
    element selected.normal {
        background-color: #313244; /* Catppuccin Surface0 */
        text-color: #cba6f7; /* Catppuccin Mauve */
    }
')

# Apply profiles
case "$chosen" in
    "$perf") powerprofilesctl set performance ;;
    "$bal") powerprofilesctl set balanced ;;
    "$save") powerprofilesctl set power-saver ;;
esac