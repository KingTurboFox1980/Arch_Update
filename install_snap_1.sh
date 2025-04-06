#!/bin/bash

# Step 1: Install Snap

git clone https://aur.archlinux.org/snapd.git

cd snapd

makepkg -si

sudo systemctl enable --now snapd.socket

sudo ln -s /var/lib/snapd/snap /snap

# Step 2: Reboot the PC

sudo reboot


# Step 3: Run another command after reboot

# This part of the script will execute after the system restarts

# Auto install apps

sudo snap install onenote-desktop
sudo snap install apple-music-for-linux
sudo snap install whatsapp-linux-app
sudo snap install bluemail
sudo snap install krita
sudo snap install qbittorrent-arnatious
