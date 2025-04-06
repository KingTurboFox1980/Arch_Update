#!/bin/bash

sudo pacman -S qemu-full

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
sudo virsh net-start default
sudo virsh net-autostart default
