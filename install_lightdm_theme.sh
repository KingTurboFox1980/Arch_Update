#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Install LightDM
sudo pacman -S lightdm

# Enable lightdm service
sudo systemctl enable lightdm.service
sudo systemctl start lightdm.service

# Install the theme from AUR using yay or makepkg
if command -v yay &> /dev/null
then
    yay -Syu lightdm-webkit2-theme-glorious
else
    git clone https://aur.archlinux.org/lightdm-webkit2-theme-glorious.git
    cd lightdm-webkit2-theme-glorious
    makepkg -sri
    cd ..
    rm -rf lightdm-webkit2-theme-glorious
fi

# Set lightdm greeter session to webkit2
sudo sed -i 's/^\(#*\)\(greeter-session\s*=\s*\).*/\2lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf

# Set lightdm-webkit2-greeter theme to Glorious and enable debug_mode
sudo sed -i 's/^webkit_theme\s*=.*/webkit_theme = glorious/' /etc/lightdm/lightdm-webkit2-greeter.conf
sudo sed -i 's/^debug_mode\s*=.*/debug_mode = true/' /etc/lightdm/lightdm-webkit2-greeter.conf

# Notification of completion
notify-send -u normal "LightDM Webkit2 Theme Glorious installed and configured successfully!"
echo "LightDM Webkit2 Theme Glorious installed and configured successfully!"
