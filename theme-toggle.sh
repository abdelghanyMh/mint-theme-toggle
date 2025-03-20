#!/bin/bash

# Load configuration
CONFIG_FILE="$HOME/.config/mint-theme-toggle/themes.conf"
if [ ! -f "$CONFIG_FILE" ]; then
    notify-send "Theme Toggle Error" "Configuration file not found!" --icon=dialog-error
    exit 1
fi

source "$CONFIG_FILE"

# Get current mode
current_mode=$(gsettings get org.x.apps.portal color-scheme)

# Toggle between modes
if [[ "$current_mode" == "'prefer-dark'" ]]; then
    # Switch to light mode
    gsettings set org.x.apps.portal color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.cinnamon.desktop.interface gtk-theme "$LIGHT_THEME"
    gsettings set org.cinnamon.desktop.wm.preferences theme "$LIGHT_THEME"
    gsettings set org.cinnamon.theme name "$LIGHT_THEME"
    notify-send "Theme Changed" "Switched to Light Mode" --icon=weather-clear
else
    # Switch to dark mode
    gsettings set org.x.apps.portal color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.cinnamon.desktop.interface gtk-theme "$DARK_THEME"
    gsettings set org.cinnamon.desktop.wm.preferences theme "$DARK_THEME"
    gsettings set org.cinnamon.theme name "$DARK_THEME"
    notify-send "Theme Changed" "Switched to Dark Mode" --icon=weather-clear-night
fi

# Apply color scheme
apply_colors() {
    # GTK3
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$1/" ~/.config/gtk-3.0/settings.ini
    sed -i "s/gtk-color-scheme=.*/gtk-color-scheme=primary_color:#$ACCENT_COLOR/" ~/.config/gtk-3.0/settings.ini
    
    # GTK4
    mkdir -p ~/.config/gtk-4.0
    echo "[Settings]" > ~/.config/gtk-4.0/settings.ini
    echo "gtk-theme-name=$1" >> ~/.config/gtk-4.0/settings.ini
    echo "gtk-accent-color=#$ACCENT_COLOR" >> ~/.config/gtk-4.0/settings.ini
}

if [[ "$current_mode" == "'prefer-dark'" ]]; then
    apply_colors "$LIGHT_THEME"
else
    apply_colors "$DARK_THEME"
fi