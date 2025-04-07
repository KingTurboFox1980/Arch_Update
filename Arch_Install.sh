#!/bin/bash

set -e

# Install prerequisite packages

sudo pacman -Syu --needed base-devel git reflector

# PARU
git clone https://aur.archlinux.org/paru.git

cd paru

makepkg -si

cd ..
rm -rf paru

# Refresh mirror list

sudo reflector --country 'Canada, US' --latest 10 --age 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Install Packages

paru -S --noconfirm timeshift timeshift-autosnap snapmate arandr pacseek bitwarden cmatrix yay ffmpeg neovim floorp-bin gvfs-smb cifs-utils thunar-extended thunar-archive-plugin thunar-volman ffmpegthumbnailer nordic-theme zsh htop neohtop flatpak kate krita fastfetch evolution evolution-on evolution-spamassassin evolution-bogofilter evolution-data-server evolution-ews engrampa intel-media-driver intel-media-sdk font-manager fontconfig gtk-update-icon-cache vivaldi


# Install Fonts

paru -S adobe-source-code-pro-fonts inter-font nerd-fonts-inter gnu-free-fonts gsfonts noto-fonts-emoji otf-aurulent-nerd otf-codenewroman-nerd otf-droid-nerd otf-firamono-nerd otf-geist-mono-nerd otf-hermit-nerd otf-monaspace-nerd otf-overpass-nerd terminus-font ttf-0xproto-nerd ttf-agave-nerd ttf-anonymouspro-nerd ttf-arimo-nerd ttf-bigblueterminal-nerd ttf-bitstream-vera-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-dejavu-nerd ttf-firacode-nerd noto-fonts ttf-freefont ttf-ms-fonts ttf-linux-libertine ttf-dejavu ttf-inconsolata ttf-ubuntu-font-family noto-fonts-cjk

sudo fc-cache -fv


# Install Icons

paru -S --noconfirm papirus-icon-theme breeze-icons hicolor-icon-theme kiconthemes beautyline candy-icons-git

#Install Layan Cursors

git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors
./install.sh

# Update package databases

sudo pacman -Sy

# Upgrade all installed packages

sudo pacman -Su

# Install or update AUR helper (paru)

paru


# Remove redundant packages

sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# Install Starship
sudo pacman -S starship

# Add Starship initialization to Bash configuration
if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# Reload .bashrc to apply changes
source ~/.bashrc


echo "Mirrors updated, packages upgraded, redundant packages removed, and cache cleared successfully!"



echo "Zsh installed and configured successfully!"



