#!/bin/bash

rm -f ~/.local/bin/theme-toggle.sh
rm -f ~/.local/share/applications/theme-toggle.desktop
rm -rf ~/.config/mint-theme-toggle
update-desktop-database ~/.local/share/applications
echo "Uninstallation complete! All configurations removed."