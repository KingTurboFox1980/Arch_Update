#!/bin/bash

sudo pacman -Sy
sudo pacman -S iptables-nft
sudo pacman -S ebtables
sudo pacman -S archlinux-keyring
sudo pacman -S qemu
sudo pacman -S virt-manager
sudo pacman -S virt-viewer
sudo pacman -S dnsmasq
sudo pacman -S vde2
sudo pacman -S bridge-utils
sudo pacman -S openbsd-netcat
sudo pacman -S dmidecode
sudo pacman -S nftables
sudo pacman -S libguestfs
sudo pacman -S ovmf
sudo pacman -S swtpm
sudo pacman -S tuned
sudo systemctl enable --now tuned
tuned-adm active
sudo tuned-adm profile virtual-host
tuned-adm list
