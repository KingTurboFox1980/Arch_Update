## ///// NIX PACKAGE MANAGER /////

# Set up Nix Package Manager (As shown here: https://github.com/dnkmmr69420/nix-installer-scripts)
case $NAME in
    ("Nobara Linux")
    echo "Nobara is being used."

    # Set up Nix without SELinux.
    curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-installer.sh | bash
    ;;
    ("Fedora") # This is for Fedora specific stuff that can safely be ignored with Nobara.
    echo "Fedora is being used."

    # Set up Nix using SELinux.
    curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/installer-scripts/regular-nix-installer-selinux.sh | bash
    ;;
esac

# Add Nix packages to Desktop Environment Start Menu
sudo rm -f /etc/profile.d/nix-app-icons.sh ; sudo wget -P /etc/profile.d https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/other-files/nix-app-icons.sh

# Set up Sudo to detect Nix commands
bash <(curl -s https://raw.githubusercontent.com/dnkmmr69420/nix-installer-scripts/main/other-scripts/nix-linker.sh)

# Add NixGL support (For OpenGL & Vulkan applications, as shown here: https://github.com/nix-community/nixGL).
nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
nix-env -iA nixgl.auto.nixGLDefault   # or replace `nixGLDefault` with your desired wrapper

# Automatically Configure DNF to be a bit faster, and gives the changes a test drive.
sudo bash -c 'echo 'max_parallel_downloads=10' >> /etc/dnf/dnf.conf && echo 'defaultyes=True' >> /etc/dnf/dnf.conf
sudo dnf update -y


    # Safely remove something that causes "kde-settings conflicts with f[version]-backgrounds-kde"
    sudo rpm -e --nodeps f$(rpm -E %fedora)-backgrounds-kde
    ;;
    ("Fedora") # This is for Fedora specific stuff that can safely be ignored with Nobara.
    echo "Fedora is being used."

    # Install third-party repositories (Via RPMFusion).
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
    sudo dnf group update core -y

    # Enable Flatpaks.
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ;;
esac

# Enable System Theming with Flatpak (That way, theming is more consistent between native apps and flatpaks).
sudo flatpak override --filesystem=xdg-config/gtk-3.0

# Enable mouse Cursors and Icons in Flatpak (That way, your mouse cursor is shown properly).
flatpak --user override --filesystem=/home/$USER/.icons/:ro
flatpak --user override --filesystem=/usr/share/icons/:ro

# Set up Flatseal for Flatpak permissions
flatpak install flathub com.github.tchx84.Flatseal $FLATPAK_TYPE -y

# Set up Homebrew Package Manager
sudo yum groupinstall 'Development Tools' -y
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.bash_profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
# Update using DNF Distro-Sync
sudo dnf distro-sync -y

# Install fastfetch, alongside some font dependencies.
sudo dnf install google-noto-sans* fastfetch -y
mkdir ~/.config/fastfetch

# Install oh-my-bash alongside changing the default theme.
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/OSH_THEME="font"/OSH_THEME="agnoster"/g' ~/.bashrc

# Install Microsoft's software repositories.
sudo dnf install https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/packages-microsoft-prod.rpm -y
# Set up Powershell.
POWERSHELL_REPONAME="PowerShell/PowerShell"
POWERSHELL_VER=$(get_latest_github_release ${POWERSHELL_REPONAME})
POWERSHELL_VER_WOSUFFIX=$(get_latest_github_release ${POWERSHELL_REPONAME} | sed 's/^v//')  # Remove the 'v' prefix from the version number
POWERSHELL_FILE="powershell-${POWERSHELL_VER_WOSUFFIX}-1.rh.x86_64.rpm"

echo $POWERSHELL_FILE
echo $POWERSHELL_VER

## Construct the download URL with the rearranged version
sudo dnf install https://github.com/$POWERSHELL_REPONAME/releases/download/$POWERSHELL_VER/$POWERSHELL_FILE -y



 # Install Steam and Steam-Devices.
    sudo dnf install steam steam-devices -y
    flatpak install flathub net.davidotek.pupgui2 $FLATPAK_TYPE -y
    
# Install MangoHud with GOverlay, alongside Gamescope and vkBasalt.
    sudo dnf install goverlay -y && sudo dnf install vkBasalt -y && sudo dnf install gamescope -y
    
# Install Lutris
    flatpak install flathub net.lutris.Lutris $FLATPAK_TYPE -y

    # Install gamemode alongside enabling the gamemode service.
    sudo dnf install gamemode -y && systemctl --user enable gamemoded.service && systemctl --user start gamemoded.service

    # Install OBS Studio.
    flatpak install flathub com.obsproject.Studio $FLATPAK_TYPE -y

    # Install GStreamer Plugin for OBS Studio, alongside some plugins.
    flatpak install com.obsproject.Studio.Plugin.Gstreamer org.freedesktop.Platform.GStreamer.gstreamer-vaapi $FLATPAK_TYPE -y
    flatpak install org.freedesktop.Platform.VulkanLayer.OBSVkCapture com.obsproject.Studio.Plugin.OBSVkCapture $FLATPAK_TYPE -y

    # Installs the needed hooks to get vkcapture in OBS to work.
    sudo dnf install obs-studio-devel obs-studio-libs -y
    git clone https://github.com/nowrep/obs-vkcapture && cd obs-vkcapture
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib ..
    make && sudo make install
    cd .. && cd .. & sudo rm -rf obs-vkcapture

    # Set up SuperGFXCTL and the SuperGFXCTL Plasmoid for Laptop GPU switching.
    sudo dnf copr enable gloriouseggroll/nobara
    sudo dnf install supergfxctl supergfxctl-plasmoid -y
    sudo dnf copr disable gloriouseggroll/nobara
    sudo systemctl enable supergfxd && sudo systemctl start supergfxd
    ;;
esac

# Add Gamescope Session and Steam Deck Gyro DSU for Switch/WiiU emulation.
case $NAME in
    ("Fedora")
    # Setup Gamescope Session.
    git clone https://github.com/ChimeraOS/gamescope-session --recursive
    git clone https://github.com/ChimeraOS/gamescope-session-steam --recursive
    cd gamescope-session && sudo cp -r usr/* /usr
    cd ..
    cd gamescope-session-steam && sudo cp -r usr/* /usr
    cd ..
    sudo rm -rf gamescope-session gamescope-session-steam
    sudo rm -rf /usr/share/wayland-sessions/gamescope-session.desktop
    # Set up SteamDeckGyroDSU.
    bash <(curl -sL https://raw.githubusercontent.com/kmicki/SteamDeckGyroDSU/master/pkg/update.sh)
    ;;
    ("Nobara Linux") # This is for Fedora specific stuff that can safely be ignored with Fedora.
    sudo dnf install sdgyrodsu gamescope-session jupiter-hw-support jupiter-fan-control -y
    ;;
esac

# TODO: Add Nobara's Gamescope Session here. Note: To prevent Steam from starting up without DPI Scaling or anything, run "sudo rm -rf /etc/xdg/autostart/steam.desktop".

# Set up Decky Loader for Steam.
curl -L https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh    

# Set up the OBS Studio shortcut to use the propreitary AMD drivers, so AMF encoding can be used instead.
cp /usr/share/applications/com.obsproject.Studio.desktop ~/.local/share/applications
sed -i 's/^Exec=/Exec=vk_pro /' ~/.local/share/applications/com.obsproject.Studio.desktop

# Install the needed OBS-VKCapture layer for Flatpak software (Useful for games on Heroic, or the Anime Game Launchers).
flatpak install org.freedesktop.Platform.VulkanLayer.OBSVkCapture $FLATPAK_TYPE -y

# Install some game launcher and emulator Flatpaks.
flatpak install flathub com.heroicgameslauncher.hgl $FLATPAK_TYPE -y
flatpak install flathub net.rpcs3.RPCS3 $FLATPAK_TYPE -y
flatpak install flathub org.yuzu_emu.yuzu $FLATPAK_TYPE -y
flatpak install flathub org.ryujinx.Ryujinx $FLATPAK_TYPE -y
flatpak install flathub org.DolphinEmu.dolphin-emu $FLATPAK_TYPE -y
flatpak install flathub net.pcsx2.PCSX2 $FLATPAK_TYPE -y
flatpak install flathub org.prismlauncher.PrismLauncher $FLATPAK_TYPE -y
flatpak install flathub org.vinegarhq.Vinegar $FLATPAK_TYPE -y
flatpak install flathub dev.goats.xivlauncher $FLATPAK_TYPE -y
flatpak remote-add --if-not-exists --user launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
flatpak install flathub org.gnome.Platform//45 $FLATPAK_TYPE -y # Install a specific GTK dependency for AAGL and HRWL.
flatpak install flathub org.freedesktop.Platform.VulkanLayer.gamescope $FLATPAK_TYPE -y # Install Gamescope dependency for AAGL and HRWL.
flatpak remove com.valvesoftware.Steam.Utility.gamescope -y # Remove the old Gamescope dependency if it exists.
flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud $FLATPAK_TYPE -y # Install MangoHud dependency for Heroic, AAGL, Lutris, and HRWL.
flatpak install flathub org.freedesktop.Platform.VulkanLayer.OBSVkCapture $FLATPAK_TYPE -y # Install OBS VkCapture layer for OBS capturing of Flatpak games.
flatpak install flathub com.valvesoftware.Steam.Utility.vkBasalt $FLATPAK_TYPE -y # Install VkBasalt for Flatpak games.
sudo flatpak override --filesystem=xdg-config/MangoHud:ro # Set up all Flatpaks to use our own MangoHUD config from GOverlay.
flatpak override --user --talk-name=com.feralinteractive.GameMode # Set up Gamemode override for MangoHUD Flatpak.
flatpak install launcher.moe moe.launcher.an-anime-game-launcher --user -y
flatpak install launcher.moe moe.launcher.the-honkers-railway-launcher --user -y
flatpak install launcher.moe moe.launcher.honkers-launcher --user -y
flatpak install flathub com.steamgriddb.steam-rom-manager $FLATPAK_TYPE -y

# Install some Proton related stuff (for game compatibility)
flatpak install flathub com.github.Matoking.protontricks $FLATPAK_TYPE -y

# Install a Soundboard Application, for micspamming in Team Fortress 2 servers, of course! ;-)
sudo dnf copr enable rivenirvana/soundux -y && sudo dnf install soundux pipewire-devel -y

# Set up Sunshine and Moonlight Streaming.
sudo dnf install https://github.com/LizardByte/Sunshine/releases/download/v0.20.0/sunshine-fedora-$(rpm -E %fedora)-amd64.rpm -y
echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"' | \
sudo tee /etc/udev/rules.d/85-sunshine.rules
systemctl --user enable sunshine
sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))
flatpak install flathub com.moonlight_stream.Moonlight $FLATPAK_TYPE -y

# Install XPadNeo drivers for Xbox controllers.
case $NAME in
    ("Fedora")
    sudo dnf copr enable sentry/xpadneo -y && sudo dnf install xpadneo -y
    ;;
esac

# Do some user permission stuff, so we don't have to dick with reinstalling the Xbox drivers through Nobara's setup GUI after a restart
sudo usermod -a -G pkg-build $USER

## ///// WINE AND WINDOWS SOFTWARE /////

case $NAME in
    ("Fedora") # This is for Fedora specific stuff that can safely be ignored with Nobara.
    # Install 64-Bit WINE Staging, alongside some needed dependencies for later.
    dnf install wine-staging -y

    # Install Yabridge (For VST Plugins, I'm going to assume you will set up a DAW on your own accords).
    sudo dnf copr enable patrickl/yabridge -y && sudo dnf install yabridge --refresh -y

    # Install Winetricks and some other dependencies.
    sudo dnf install winetricks cabextract samba-winbind -y
    # Set up realtime, jackuser, and audiogroups alongside necessary permissions.
    echo -e '@audio\trtprio 99\n@audio\tmemlock unlimited' | sudo tee -a /etc/security/limits.conf
    sudo groupadd realtime && sudo usermod -a -G realtime $(whoami)
    sudo groupadd jackuser && sudo usermod -a -G jackuser $(whoami)
    sudo usermod -a -G audio $(whoami)
    sudo sh -c 'echo "JACK_START_SERVER=1" >> /etc/environment'
    sudo sh -c 'echo "WINEASIO_AUTOSTART_SERVER=on" >> /etc/environment'

    # Open Explorer to initialize our Wine prefix.
    echo "Initializing Wine prefix. Please exit out of Explorer when it opens and follow any setup prompts."
    wine64 explorer

    # Set up some prerequisites for Wine.
    winetricks corefonts # look into avoid using winetricks for vcrun6 and dotnet462 because of the painfully long install process from the GUI installer. Fuck that.
    winetricks dotnet48

    # Ableton Stuff (Feel free to use this if you are planning to install Ableton Live. I just have it here for reference).
    # WINEPREFIX=~/.ableton wine64 explorer
    #WINEPREFIX=$HOME/.ableton winetricks win7 quicktime72 gdiplus vb2run vcrun2008 vcrun6 vcrun2010 vcrun2013 vcrun2015 tahoma msxml3 msxml6 setupapi python27
    
    # Set our Wine Prefix to use ALSA audio, so it won't crash with WineASIO or other ASIO plugins.
    WINEPREFIX=$HOME/.wine winetricks sound=alsa
    #WINEPREFIX=$HOME/.ableton winetricks sound=alsa
    ;;
    
wget https://aka.ms/vs/17/release/vc_redist.x86.exe
wget https://aka.ms/vs/17/release/vc_redist.x64.exe
wget https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe
wine64 ndp462-kb3151800-x86-x64-allos-enu.exe
wine64 vc_redist.x86.exe /quiet /norestart
wine64 vc_redist.x64.exe /quiet /norestart
rm vc_redist.x86.exe vc_redist.x64.exe NDP462-KB3151800-x86-x64-AllOS-ENU.exe

# Set up Bottles.
flatpak install flathub com.usebottles.bottles $FLATPAK_TYPE -y
flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications

# Set up Samba
sudo dnf install samba -y
sudo systemctl enable smb nmb && sudo systemctl start smb nmb
case $XDG_CURRENT_DESKTOP in
    ("KDE") # Install the KDE Plasma extension for Samba Shares, alongside setting up the needed permissions.
    sudo dnf install kdenetwork-filesharing -y
    sudo groupadd sambashares && sudo usermod -a -G sambashares $USER
    sudo mkdir /var/lib/samba/usershares && sudo chgrp sambashares /var/lib/samba/usershares && sudo chown $USER:sambashares /var/lib/samba/usershares
    ;;
esac
sudo setsebool -P samba_enable_home_dirs=on

# Set up SSH Server on Host
sudo systemctl enable sshd && sudo systemctl start sshd

# Disable NetworkManager Wait Service (due to long boot times) if using a desktop. Assuming this based on if a battery is available.
if [ -f /sys/class/power_supply/BAT1/uevent ]
    then echo "Battery is available. Skipping disabling the NetworkManager Wait Service."
else sudo systemctl disable NetworkManager-wait-online.service
fi

# Install Epic Asset Manager (For Unreal Engine)
flatpak install flathub io.github.achetagames.epic_asset_manager $FLATPAK_TYPE -y

# Install Docker alongside setting up DockStation.
sudo dnf install dnf-plugins-core -y
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
sudo groupadd docker && sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker && sudo systemctl start docker
wget -O ~/Applications/Dockstation.AppImage https://github.com/DockStation/dockstation/releases/download/v1.5.1/dockstation-1.5.1-x86_64.AppImage

# Install Distrobox and Podman (So Distrobox doesn't use Docker instead).
sudo dnf install podman distrobox -y

# Install MinGW64, CMake, Ninja Build
sudo dnf install mingw64-\* cmake ninja-build -y --exclude=mingw64-libgsf --skip-broken
sudo dnf remove mingw64-libgsf -y # This is just in case we want to install the gnome desktop via 'dnf group install -y "GNOME Desktop Environment"'.

# Install Ghidra.
flatpak install flathub org.ghidra_sre.Ghidra $FLATPAK_TYPE -y && sudo flatpak override org.ghidra_sre.Ghidra --filesystem=/mnt

# Install Visual Studio Code.
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && sudo dnf check-update && sudo dnf install code -y

# Install several dependencies for CheatEngine-Proton-Helper
sudo dnf install python3-vdf yad xdotool -y

# Install a hex editor
sudo dnf install okteta -y

# Install GitHub Desktop
sudo rpm --import https://rpm.packages.shiftkey.dev/gpg.key
sudo sh -c 'echo -e "[shiftkey-packages]\nname=GitHub Desktop\nbaseurl=https://rpm.packages.shiftkey.dev/rpm/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://rpm.packages.shiftkey.dev/gpg.key" > /etc/yum.repos.d/shiftkey-packages.repo'
sudo dnf install github-desktop -y

# Install .NET Runtime/SDK and Mono (for Rider and C# applications)
sudo dnf install dotnet-sdk-6.0 dotnet-sdk-7.0 dotnet-sdk-8.0 mono-devel -y

# Install Java
sudo dnf install java -y

# Install Ruby alongside some Gems.
sudo dnf install ruby ruby-devel rubygem-\* --skip-broken -y

# Install Python 2.
sudo dnf install python2 -y

# Install Rust. Alternatively, you can run this: "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh".
sudo dnf install rust -y

# Set up Virtualization Tools.
if grep -Eq 'vmx|svm' /proc/cpuinfo; then
    echo "Virtualization is enabled. Setting up virtualization packages."
    # Installs Virtual Machine related packages, alongside downloading the current stable VirtIO Guest Driver ISO.
    sudo dnf -y group install Virtualization -y
    wget -O ~/Downloads/virtio-win.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

    # Set up Cockpit for Virtual Machines (As Virt-Manager is now discontinued).
    sudo dnf install cockpit cockpit-machines -y
    sudo systemctl enable --now cockpit.socket
    sudo firewall-cmd --add-service=cockpit && sudo firewall-cmd --add-service=cockpit --permanent
    # Connect to cockpit with https://localhost:9090

    # Set up GRUB Bootloader to use IOMMU based on the CPU type used
    cpu_vendor=$(grep -m 1 vendor_id /proc/cpuinfo | cut -d ":" -f 2 | tr -d '[:space:]')
    if [ "$cpu_vendor" = "GenuineIntel" ]; then
        echo "CPU vendor is Intel. Setting up Intel IOMMU boot parameters."
        sudo grubby --update-kernel=ALL --args="intel_iommu=on iommu=pt video=vesafb:off,efifb:off"
        # If you want iGPU passthrough for some reason, you can add "i915.modeset=0" to the end of the intel parameters.
    elif [ "$cpu_vendor" = "AuthenticAMD" ]; then
        echo "CPU vendor is AMD. Setting up AMD IOMMU boot parameters."
        sudo grubby --update-kernel=ALL --args="amd_iommu=on iommu=pt video=vesafb:off,efifb:off"
    else
        echo "Unknown CPU vendor. Skipping."
    fi
    sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg

    # Set up user permissions with libvirt
    sudo usermod -a -G libvirt $(whoami) && sudo usermod -a -G kvm $(whoami) && sudo usermod -a -G input $(whoami)
    sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
    sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf

    # Add needed GPU Passthrough Hooks (This will be commented out for the time being, as it's not automated).
	# sudo mkdir -p /etc/libvirt/hooks
	# sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' -O /etc/libvirt/hooks/qemu
	# sudo chmod +x /etc/libvirt/hooks/qemu

	# Make the directories for our VM Release/Prepare Scripts
	# sudo mkdir '/etc/libvirt/hooks/qemu.d'
	# sudo mkdir '/etc/libvirt/hooks/qemu.d/Win11' && sudo mkdir '/etc/libvirt/hooks/qemu.d/Win11/prepare' && sudo mkdir '/etc/libvirt/hooks/qemu.d/Win11/prepare/begin' && sudo mkdir '/etc/libvirt/hooks/qemu.d/Win11/release' && sudo mkdir '/etc/libvirt/hooks/qemu.d/Win11/release/end'

	# sudo echo -e "#!/bin/bash
	# Helpful to read output when debugging
	# set -x

	# Load the config file with our environmental variables
	# source \"/etc/libvirt/hooks/kvm.conf\"

 	# Stops our Plasma session on Wayland before stopping the display manager.
 	# systemctl --user -M $USER@ stop plasma* # This line may need to be changed from $USER to a hardcoded username to work properly.

	# Stop your display manager. If you're on KDE, it'll be sddm.service. Gnome users should use killall gdm-x-session instead
	# systemctl stop sddm.service
	# pulse_pid=$(pgrep -u YOURUSERNAME pulseaudio)
	# pipewire_pid=$(pgrep -u YOURUSERNAME pipewire-media)
	# kill $pulse_pid
	# kill $pipewire_pid

	# Unbind VTconsoles
	# echo 0 > /sys/class/vtconsole/vtcon0/bind
	# echo 0 > /sys/class/vtconsole/vtcon1/bind

	# Avoid a race condition by waiting a couple of seconds. This can be calibrated to be shorter or longer if required for your system
	# sleep 4

	# Unload all Radeon drivers

	# modprobe -r amdgpu
	# modprobe -r gpu_sched
	# modprobe -r ttm
	# modprobe -r drm_kms_helper
	# modprobe -r i2c_algo_bit
	# modprobe -r drm
	# modprobe -r snd_hda_intel

	# Unbind the GPU from display driver
	# virsh nodedev-detach $VIRSH_GPU_VIDEO
	# virsh nodedev-detach $VIRSH_GPU_AUDIO

	# Load VFIO kernel module
	# modprobe vfio
	# modprobe vfio_pci
	# modprobe vfio_iommu_type1
	# " >> '/etc/libvirt/hooks/qemu.d/Win11/prepare/begin/start.sh'
	# sudo chmod +x '/etc/libvirt/hooks/qemu.d/Win11/prepare/begin/start.sh'

	# sudo echo -e "#!/bin/bash
	# Helpful to read output when debugging
	# set -x

	# Load the config file with our environmental variables
	# source \"/etc/libvirt/hooks/kvm.conf\"

	# Unload all the vfio modules
	# modprobe -r vfio_pci
	# modprobe -r vfio_iommu_type1
	# modprobe -r vfio

	# Reattach the GPU
	# virsh nodedev-reattach $VIRSH_GPU_VIDEO
	# virsh nodedev-reattach $VIRSH_GPU_AUDIO

	# Load all Radeon drivers
	# modprobe amdgpu
	# modprobe gpu_sched
	# modprobe ttm
	# modprobe drm_kms_helper
	# modprobe i2c_algo_bit
	# modprobe drm
	# modprobe snd_hda_intel

	# Start your display manager
	# systemctl start sddm.service
	# " >> '/etc/libvirt/hooks/qemu.d/Win11/release/end/stop.sh'
	# sudo chmod +x '/etc/libvirt/hooks/qemu.d/Win11/release/end/stop.sh'

	# sudo echo -e "VIRSH_GPU_VIDEO=pci_0000_0a_00_0
	# VIRSH_GPU_AUDIO=pci_0000_0a_00_1" >> '/etc/libvirt/hooks/kvm.conf'

	# Download the RX 6700XT VBIOS that I use specifically (An ASUS ROG STRIX OC Edition)
 	# sudo mkdir /usr/share/vgabios
	# sudo wget -O /usr/share/vgabios/GPU.rom https://www.techpowerup.com/vgabios/230897/Asus.RX6700XT.12288.210301.rom
	# sudo chmod -R 775 /usr/share/vgabios/GPU.rom && sudo chown $(whoami):$(whoami) /usr/share/vgabios/GPU.rom

    # Finally restart the Libvirt service.
    sudo systemctl restart libvirtd.service
else
    echo "Virtualization is not enabled. Skipping."
fi

## ///// GENERAL DESKTOP USAGE /////

# Set Wayland as the default SDDM Greeter, so we can actually see the login splash screen.
#echo "DisplayServer=wayland" | sudo tee -a /etc/sddm.conf > /dev/null

# Set up Timeshift for system backups.
case $NAME in
    ("Fedora")
    sudo dnf install timeshift -y
    ;;
esac

# Install the tiled window management KWin plugin, Bismuth.
sudo dnf install bismuth qt -y

# Add KDE Rounded Corners plugin, and then add updated desktop effects config.
sudo dnf install git cmake gcc-c++ extra-cmake-modules kwin-devel kf6-kconfigwidgets-devel libepoxy-devel kf6-kcmutils-devel qt6-qtbase-private-devel wayland-devel -y
git clone https://github.com/matinlotfali/KDE-Rounded-Corners
cd KDE-Rounded-Corners
mkdir build
cd build
cmake .. --install-prefix /usr
make
sudo make install
cd .. && cd .. && sudo rm -rf KDE-Rounded-Corners

# Install the BETTER partition manager and a disk space utility.
sudo dnf install gnome-disk-utility filelight -y

# Remove some KDE Plasma bloatware that comes installed for some reason.
sudo dnf remove libreoffice-\* akregator ksysguard dnfdragora kfind kmag kmail kcolorchooser kmouth korganizer kmousetool kruler kaddressbook kcharselect konversation elisa-player kmahjongg kpat kmines dragonplayer kamoso kolourpaint krdc krfb -y

# Remove KWrite in favor of Kate.
sudo dnf remove kwrite -y && sudo dnf install kate -y

# Install Input-Remapper (For Razer Tartarus Pro)
sudo dnf install input-remapper -y
sudo systemctl enable --now input-remapper && sudo systemctl start input-remapper

# Install some Flatpaks that I personally use.
flatpak install flathub com.spotify.Client $FLATPAK_TYPE -y

# TODO: Replace with Thunderbird.
# Install an email client.
case $XDG_CURRENT_DESKTOP in
    ("KDE")
    sudo dnf install kmail -y
    ;;
    ("gnome")
    sudo dnf install geary -y
esac

# Install a Torrent client.
sudo dnf install qbittorrent -y

# Install and Setup OneDrive alongside OneDrive GUI for a GUI interface.
sudo dnf install onedrive -y && sudo systemctl stop onedrive@$USER.service && sudo systemctl disable onedrive@$USER.service && systemctl --user enable onedrive && systemctl --user start onedrive
ONEDRIVEGUI_VER=$(get_latest_github_release "bpozdena/OneDriveGUI" | sed 's/v//')
ONEDRIVEGUI_APPIMAGE="OneDriveGUI-${ONEDRIVEGUI_VER}-x86_64.AppImage"
echo $ONEDRIVEGUI_APPIMAGE
echo $ONEDRIVEGUI_VER
wget -O ~/Applications/$ONEDRIVEGUI_APPIMAGE https://github.com/bpozdena/OneDriveGUI/releases/download/v$ONEDRIVEGUI_VER/$ONEDRIVEGUI_APPIMAGE
echo "Make sure to run AppImageLauncher at least once, to get it to recognize the AppImage for OneDriveGUI. Afterwards, synchronize your account, and add a login application startup for the OneDrive GUI.".

# Install Mullvad VPN.
## Add the Mullvad repository server to dnf
sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo
## Install the package
sudo dnf install mullvad-vpn -y

## ///// MEDIA CODECS AND SUCH /////

case $NAME in
    ("Fedora") # This is for Fedora specific stuff that can safely be ignored with Nobara.
    # Install Mesa Freeworld, so we can get FFMPEG back.
    sudo dnf install mesa-vdpau-drivers -y
    sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld -y
    sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld -y

    # Add some optional codecs
    sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
    sudo dnf groupupdate sound-and-video -y
    sudo dnf install @multimedia @sound-and-video ffmpeg-libs gstreamer1-plugins-{bad-*,good-*,base} gstreamer1-plugin-openh264 gstreamer1-libav lame* -y

    # Install Media Codecs and Plugins.
    sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y && sudo dnf install lame\* --exclude=lame-devel -y && sudo dnf group upgrade --with-optional Multimedia -y
    sudo dnf install vlc -y
    ;;
esac

# Install YT-DLP
sudo dnf install yt-dlp -y

# Install FFMPEG for Flatpak.
flatpak install flathub org.freedesktop.Platform.ffmpeg-full $FLATPAK_TYPE -y

# Install Better Fonts.
sudo dnf copr enable dawid/better_fonts -y && sudo dnf install fontconfig-font-replacements -y --skip-broken && sudo dnf install fontconfig-enhanced-defaults -y --skip-broken

# Install FontAwesome Fonts.
sudo dnf install fontawesome-fonts fontawesome5-brands-fonts -y

# Install Microsoft Fonts.
sudo dnf install curl cabextract xorg-x11-font-utils fontconfig -y
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
# Some other Microsoft fonts not included with msttcore-fonts. You may need to restart your PC for the fonts to appear.
wget -q -O - https://gist.githubusercontent.com/Blastoise/72e10b8af5ca359772ee64b6dba33c91/raw/2d7ab3caa27faa61beca9fbf7d3aca6ce9a25916/clearType.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/b74e06f739610c4a867cf94b27637a56/raw/96926e732a38d3da860624114990121d71c08ea1/tahoma.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/64ba4acc55047a53b680c1b3072dd985/raw/6bdf69384da4783cc6dafcb51d281cb3ddcb7ca0/segoeUI.sh | bash
wget -q -O - https://gist.githubusercontent.com/Blastoise/d959d3196fb3937b36969013d96740e0/raw/429d8882b7c34e5dbd7b9cbc9d0079de5bd9e3aa/otherFonts.sh | bash

# Set up Google Fonts.
wget -O ~/.fonts/google-fonts.zip https://github.com/google/fonts/archive/master.zip
mkdir ~/.fonts/Google && unzip -d ~/.fonts/Google ~/.fonts/google-fonts.zip

# Finally updates our Font Cache.
sudo fc-cache -fv

## Add nerd-fonts for Noto and SourceCodePro font families. This will just install everything together, but I give no fucks at this point, just want things a little easier to set up.
git clone https://github.com/ryanoasis/nerd-fonts.git && cd nerd-fonts && ./install.sh && cd .. && sudo rm -rf nerd-fonts

# ///// GRUB BOOTLOADER MODIFICATIONS /////
# Adjust GRUB bootloader settings to only show the menu if I hold shift, and to reduce the countdown timer from 5 to 3 for a quicker boot.
new_timeout=3
# Check if GRUB_TIMEOUT exists in the configuration file, and if it does, replace its value with the new_timeout. If not, add it to the end of the file.
if grep -q '^GRUB_TIMEOUT=' /etc/default/grub; then
    sudo sed -Ei "s/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$new_timeout/" /etc/default/grub
else
    sudo sed -i "$ a GRUB_TIMEOUT=$new_timeout" /etc/default/grub
fi
# Check if GRUB_TIMEOUT_STYLE exists in the configuration file, and if it does, replace its value with "hidden". If not, add it to the end of the file.
if grep -q '^GRUB_TIMEOUT_STYLE=' /etc/default/grub; then
    sudo sed -Ei 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
else
    sudo sed -i "$ a GRUB_TIMEOUT_STYLE=hidden" /etc/default/grub
fi
sudo grub2-mkconfig -o /etc/grub2.cfg && sudo grub2-mkconfig -o /etc/grub2-efi.cfg


# Install oh-my-posh for Powershell.
curl -s https://ohmyposh.dev/install.sh | sudo bash -s
# Downloads our custom powershell profile.
wget -O ~/.config/powershell/Microsoft.Powershell_profile.ps1 https://github.com/KingKrouch/Fedora-InstallScripts/raw/main/.config/powershell/Microsoft.PowerShell_profile.ps1

# Install zsh, alongside setting up oh-my-zsh, and powerlevel10k.
sudo dnf install zsh -y && chsh -s $(which zsh) && sudo chsh -s $(which zsh)
sudo dnf install git git-lfs -y && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"c
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
wget -O ~/.p10k.zsh https://github.com/KingKrouch/Fedora-InstallScripts/raw/main/.p10k.zsh

# Set up Powerlevel10k as the default zsh theme, alongside enabling some tweaks.
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc
echo "# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> tee -a ~/.zshrc
echo "typeset -g POWERLEVEL9K_INSTANT_PROMPT=off" >> tee -a ~/.zshrc

# Set up some ZSH plugins.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# TODO: Fix sed command.
sed -i 's/plugins=(git)/plugins=(git emoji zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
