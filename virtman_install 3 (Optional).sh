#!/bin/bash

sudo pacman -S tuned
sudo systemctl enable --now tuned
tuned-adm active
sudo tuned-adm profile virtual-host
tuned-adm list
