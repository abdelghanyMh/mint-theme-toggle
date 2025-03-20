#!/bin/bash

# Create necessary directories
mkdir -p ~/.local/bin ~/.local/share/applications ~/.config/mint-theme-toggle

# Install main files
cp theme-toggle.sh ~/.local/bin/
cp theme-toggle.desktop ~/.local/share/applications/
chmod +x ~/.local/bin/theme-toggle.sh

# Check if configuration exists
if [ ! -f ~/.config/mint-theme-toggle/themes.conf ]; then
    echo "Starting interactive theme setup..."
    echo
    
    # Get available themes
    mapfile -t themes < <(find /usr/share/themes ~/.themes -maxdepth 1 -type d -printf "%f\n" | sort -u)
    
    # Light theme selection
    echo "Available light themes:"
    PS3="Select light theme number: "
    select light_theme in "${themes[@]}"; do
        [[ -n $light_theme ]] && break
        echo "Invalid selection!"
    done
    
    # Dark theme selection
    echo -e "\nAvailable dark themes:"
    PS3="Select dark theme number: "
    select dark_theme in "${themes[@]}"; do
        [[ -n $dark_theme ]] && break
        echo "Invalid selection!"
    done
    
    # Color scheme setup
    echo -e "\nColor scheme configuration (hex format):"
    accent_color=$(zenity --color-selection --title="Select Accent Color" | cut -d'#' -f2)
    [ -z "$accent_color" ] && accent_color="4a90d9"  # Default Mint color
    
    # Create config file
    cat > ~/.config/mint-theme-toggle/themes.conf <<EOL
# Theme configuration
LIGHT_THEME="$light_theme"
DARK_THEME="$dark_theme"
ACCENT_COLOR="$accent_color"
EOL

    echo -e "\nConfiguration saved to ~/.config/mint-theme-toggle/themes.conf"
fi

# Update desktop database
update-desktop-database ~/.local/share/applications

echo -e "\nInstallation complete!\nYou can now:"
echo "- Find 'Toggle Theme' in your application menu"
echo "- Create keyboard shortcuts"
echo "- Edit ~/.config/mint-theme-toggle/themes.conf for advanced configuration"