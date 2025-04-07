#!/bin/bash

set -e

# Functions
update_mirror_list() {
  sudo reflector --country 'Canada, US' --latest 10 --age 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

install_prerequisites() {
  sudo pacman -Syu --needed base-devel git reflector
}

install_paru() {
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
  rm -rf paru
}

resolve_conflicts() {
  local packages=("$@")
  for pkg in "${packages[@]}"; do
    if pacman -Q "$pkg" &> /dev/null; then
      echo "Removing conflicting package: $pkg"
      sudo pacman -Rns "$pkg" --noconfirm
    fi
  done
}

install_fonts() {
  local conflicting_packages=(fontconfig noto-fonts noto-fonts-emoji)
  resolve_conflicts "${conflicting_packages[@]}"
  
  paru -S adobe-source-code-pro-fonts ttf-fantasque-nerd inter-font nerd-fonts-inter gnu-free-fonts gsfonts \
    noto-fonts-emoji otf-aurulent-nerd otf-codenewroman-nerd otf-droid-nerd otf-firamono-nerd otf-geist-mono-nerd \
    otf-hermit-nerd otf-monaspace-nerd otf-overpass-nerd terminus-font ttf-0xproto-nerd ttf-agave-nerd \
    ttf-anonymouspro-nerd ttf-arimo-nerd ttf-bigblueterminal-nerd ttf-bitstream-vera-mono-nerd \
    ttf-cascadia-code-nerd ttf-cascadia-mono-nerd ttf-dejavu-nerd ttf-firacode-nerd noto-fonts ttf-freefont \
    ttf-ms-fonts ttf-linux-libertine ttf-dejavu ttf-inconsolata ttf-times-new-roman ttf-ubuntu-font-family noto-fonts-cjk

  sudo fc-cache -fv
}

install_packages() {
  paru -S --noconfirm arandr bitwarden cifs-utils cmatrix code engrampa evolution evolution-bogofilter \
    evolution-data-server evolution-ews evolution-on evolution-spamassassin fastfetch ffmpeg \
    ffmpegthumbnailer firefox flatpak floorp-bin font-manager geany git gvfs-smb gtk-update-icon-cache htop \
    intel-media-driver intel-media-sdk kate krita microsoft-edge-dev-bin nordic-theme neofetch neohtop \
    neovim nwg-look-bin pacseek papirus-icon-theme qbittorrent rclone-browser reflector snapmate thunar \
    thunar-archive-plugin thunar-extended thunar-volman timeshift timeshift-autosnap vivaldi yay zsh
}

install_icons() {
  paru -S --noconfirm papirus-icon-theme breeze-icons hicolor-icon-theme kiconthemes beautyline candy-icons-git
}

install_layan_cursors() {
  git clone https://github.com/vinceliuice/Layan-cursors
  cd Layan-cursors
  ./install.sh
  cd ..
  rm -rf Layan-cursors
}

cleanup_packages() {
  sudo pacman -Rns $(pacman -Qdtq) --noconfirm || echo "No orphan packages to clean."
}

install_starship() {
  sudo pacman -S starship

  if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
  fi

  source ~/.bashrc
}

# Main Execution
echo "Starting setup..."

install_prerequisites
install_paru
update_mirror_list
install_packages
install_fonts
install_icons
install_layan_cursors
cleanup_packages
install_starship

echo "Setup completed successfully!"
