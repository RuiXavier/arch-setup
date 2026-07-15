#!/bin/bash

# Fetch weather condition text and temperature
condition=$(curl -s --max-time 2 "https://wttr.in/Brabrand?format=%C")
# Fetch temp and remove the '+' sign for a cleaner look
temp=$(curl -s --max-time 2 "https://wttr.in/Brabrand?format=%t" | sed 's/+//') 

# Validate the temperature output
# If $temp does NOT match a valid number (with optional minus) followed by °C or °F, set it to '-'
if [[ ! "$temp" =~ ^-?[0-9]+°[CF]$ ]]; then
    temp="-"
fi

# Map the condition to a beautifully spaced Nerd Font icon
case "$condition" in
    *Clear*|*Sunny*) icon="󰖙" ;;
    *Partly*Cloudy*) icon="󰖕" ;;
    *Cloudy*|*Overcast*) icon="󰖐" ;;
    *Rain*|*Drizzle*|*Showers*) icon="󰖗" ;;
    *Snow*|*Flurries*) icon="󰖘" ;;
    *Fog*|*Mist*) icon="󰖑" ;;
    *Thunder*|*Storm*) icon="󰖓" ;;
    *) icon="󰖐" ;; # Default icon if it's something weird or empty
esac

# Output formatted string for Waybar
echo "<span font_size='16pt' rise='-2000'>$icon</span>  $temp"