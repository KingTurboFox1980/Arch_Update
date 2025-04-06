 #!/bin/bash

sudo pacman -Syu --noconfirm

# Remove Neofetch
sudo pacman -Rcns neofetch

# Add Fastfetch
sudo pacman -S fastfetch --noconfirm
