#!/usr/bin/env bash

THEME=$1
HYPR_DIR="$HOME/.config/hypr/themes"
WAYBAR_DIR="$HOME/.config/waybar/themes"

if [ -z "$THEME" ]; then
    echo "Error: No theme provided."
    exit 1
fi

echo "-> Linking Hyprland theme..."
ln -sf "$HYPR_DIR/$THEME.lua" "$HYPR_DIR/current_theme.lua" # Updated to .lua

echo "-> Linking Waybar theme..."
ln -sf "$WAYBAR_DIR/$THEME.css" "$WAYBAR_DIR/current_theme.css"

echo "-> Reloading Hyprland..."
hyprctl reload

echo "-> Reloading Waybar..."
killall -SIGUSR2 waybar || echo "Waybar not running, skipping reload."

echo "Theme swap complete!"