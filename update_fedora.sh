#!/bin/bash 

# Version Info 

uname -mrs 

date


# Rclone Update  

sudo rclone selfupdate  

# Update packages 

sudo dnf5 update -y

# Upgrade packages 

sudo dnf5 upgrade -y

# Update DNF5 

sudo dnf5 install dnf5 -y

# Refresh keys 

sudo dnf5 --refresh check-update

  
# Update mirrors 

sudo dnf5 makecache
 

# Clear cache 

sudo dnf5 clean all


# Remove orphaned packages 

sudo dnf5 autoremove -y  --allowerasing

  
# Update dnf info 

sudo dnf updateinfo  --allowerasing

sudo dnf upgrade --refresh upgrade -y  --allowerasing

sudo dnf system-upgrade download --releasever=37 -y  --allowerasing
  

# Update packages 

sudo dnf update -y --allowerasing

  
# Clear cache 

sudo dnf clean all  --allowerasing
 

# Upgrade packages 

sudo dnf upgrade -y  --allowerasing

  
# Update DNF 

sudo dnf install dnf5 -y  --allowerasing


# Refresh keys 

sudo dnf --refresh check-update  --allowerasing


# Update mirrors (optional but recommended) 

sudo dnf install dnf-plugins-core -y 

sudo dnf copr enable dnf-plugins-core -y 

sudo dnf refresh -y 

# Remove orphaned packages 

sudo dnf autoremove -y 
 

# Clear cache 

sudo dnf clean all 

# Remove orphaned packages 

sudo dnf autoremove -y 


# Check for yum updates 

sudo yum check-update --allowerasing

# Update yum 

sudo yum update --allowerasing


# Delete yum cache 

sudo yum clean all 

# Yum Update

sudo yum update kernel

#Trim 

sudo fstrim -v / 

clear

# Version Info 

uname -mrs 
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
