#!/bin/bash

set -e



# Install prerequisite packages

sudo pacman -Syu --needed base-devel git



# Install Yay (AUR helper)

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si

yay --version

cd ..

rm -rf yay



# Install desired packages

yay -S --noconfirm git yay ffmpeg neovim thunar ffmpegthumbnailer nwg-look-bin nordic-theme papirus-icon-theme paru zsh htop flatpak rclone-browser microsoft-edge-dev-bin firefox qbittorrent kate krita neofetch reflector


#Install Laptop Mode Tools
git clone https://aur.archlinux.org/laptop-mode-tools-git.git
cd laptop-mode-tools-git
makepkg -si


#Install Layan Cursors
git clone https://github.com/vinceliuice/Layan-cursors
cd layan-cursor-theme-git
makepkg -si


# Install Zsh

sudo pacman -S --noconfirm zsh



# Set Zsh as the default shell

chsh -s $(which zsh)



# Install Oh My Zsh (framework for managing Zsh configuration)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"



# Change Zsh theme to Agnoster

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc



# Install or update reflector (if not already installed)

sudo pacman -S --needed reflector



# Refresh mirror list
sudo reflector --country 'Canada, US' --latest 10 --age 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist



# Update package databases

sudo pacman -Sy



# Upgrade all installed packages

sudo pacman -Su



# Install or update AUR helper (yay)

yay -Syu --noconfirm



# Remove redundant packages

sudo pacman -Rns $(pacman -Qdtq) --noconfirm



# Clear package cache

sudo paccache -r



echo "Mirrors updated, packages upgraded, redundant packages removed, and cache cleared successfully!"



echo "Zsh installed and configured successfully!"



