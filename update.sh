#!/bin/bash

# Notification at the start
notify-send -u normal "Starting App Upgrades and Performing System Maintenance"

# Display Arch version
uname -mrs
date

paru -P --stats

# Function to check if any package manager processes are running
echo -e "\e[30;48;5;10m***** REMOVING PACMAN LOCK IF ANY *****\e[0m"
check_pacman_processes() {
    if pgrep -x pacman >/dev/null || pgrep -x pamac >/dev/null || pgrep -x yay >/dev/null; then
        echo "Another package manager is currently running. Please close it before running this script."
        exit 1
    fi
}

# Function to delete the lock file if no package manager processes are running
repair_pacman_lock() {
    lock_file="/var/lib/pacman/db.lck"

    if [ -f "$lock_file" ]; then
        echo "Lock file exists: $lock_file"
        check_pacman_processes
        echo "No package manager processes found. Deleting the lock file..."
        sudo rm "$lock_file"
        echo "Lock file deleted successfully."
    else
        echo "No lock file found. No action needed."
    fi
}

# Function to update the system
update_system() {
    echo "Updating the system..."
    sudo pacman -Syu
}

# Run the functions
repair_pacman_lock
update_system

# Remove orphan packages

echo -e "\e[30;48;5;10m***** REMOVING UNUSED PACKAGES (ORPHANS) *****\e[0m"
sudo pacman -Qqtd
echo ""

# Refresh mirror list
echo -e "\e[30;48;5;10m***** REFRESHING MIRRORS *****\e[0m"
sudo reflector --country 'Canada, US' --latest 15 --age 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
echo ""

# Refresh keys
echo -e "\e[30;48;5;10m***** REFRESHING KEYS *****\e[0m"
sudo pacman-key --init
sudo pacman-key --populate archlinux
echo ""

# Refresh Font cache
sudo fc-cache -fv

# Rclone Update
echo -e "\e[30;48;5;10m***** CHECKING FOR RCLONE BROWSER UPDATES *****\e[0m"
sudo rclone selfupdate
echo ""

# Update Flatpaks
echo -e "\e[30;48;5;10m***** UPDATING FLATPAKS *****\e[0m"
sudo flatpak update
echo ""

# Update pacman repository and update packages
echo -e "\e[30;48;5;10m***** UPDATING PACMAN REPOSITORY AND PACKAGES *****\e[0m"
sudo pacman -Syyu
echo ""

# Update Snaps
echo -e "\e[30;48;5;10m***** UPDATING SNAP PACKAGES *****\e[0m"
sudo snap refresh
echo ""

# Update Keyring
echo -e "\e[30;48;5;10m***** UPDATING ARCH LINUX KEYRING *****\e[0m"
sudo pacman -Sy archlinux-keyring --noconfirm
echo ""

# yay System Update
echo -e "\e[30;48;5;10m***** YAY UPDATE *****\e[0m"
yay -Syu --noconfirm
echo ""

#Update paru
echo -e "\e[30;48;5;10m***** PARU UPDATE *****\e[0m"
paru -Sua --noconfirm
echo ""

# Clean unneeded dependencies
echo -e "\e[30;48;5;10m***** REMOVE ORPHANED DEPENDENCIES *****\e[0m"
paru -c

# Clean unneeded dependencies
yay -Yc  --noconfirm

# Remove all uninstalled package versions from the cache
sudo paccache -ruk0
echo ""

# Pruning the pacman cache
echo -e "\e[30;48;5;10m***** PRUNING THE PACKAGE CACHE *****\e[0m"
sudo paccache -r
echo ""

# Clean the Cache
# echo -e "\e[30;48;5;10m***** CLEAR CACHE *****\e[0m"
# rm -rf .cache/*
# paru -Sc
# echo ""

# Clean the journal
echo -e "\e[30;48;5;10m***** CLEANING JOURNAL *****\e[0m"
sudo journalctl --vacuum-time=2weeks
echo ""

# Display failed systemd services including inactive
echo -e "\e[30;48;5;10m***** ALL FAILED SYSTEMD SERVICES *****\e[0m"
systemctl --failed --all
echo ""

# -Hostname information:
echo -e "\e[30;48;5;10m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""

# -File system disk space usage:
echo -e "\e[30;48;5;10m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""

# -Free and used memory in the system:
echo -e "\e[30;48;5;10m***** FREE AND USED MEMORY *****\e[0m"
free
echo ""

# -System uptime and load:
echo -e "\e[30;48;5;10m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""

# -Logged-in users:
echo -e "\e[30;48;5;10m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
who
echo ""

# -Top 5 processes as far as memory usage is concerned
echo -e "\e[30;48;5;10m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""
echo -e "\e[1;32mDone.\e[0m"

# Trim
echo -e "\e[30;48;5;10m***** TRIM nVME *****\e[0m"
sudo fstrim -v /
echo ""

clear

echo
echo
echo
date
echo
echo
echo
echo "Maintenance / Updates Complete!"
echo
echo
echo

notify-send -u critical "Maintenance Complete!"
