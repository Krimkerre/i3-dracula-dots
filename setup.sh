# Contains parts of i3 install script by Johannes Kamprad #
# https://github.com/endeavouros-team/i3-EndeavourOS #
# https://github.com/killajoe #

# Contains parts of Erik Sundquist's Arch install script #
# https://github.com/lotw69/arch-scripts #

# Modified for own use by Krim Kerre #
# https://github.com/Krimkerre #

#!/usr/bin/env bash

echo "################################################################################"
echo "### Installing YAY                                                           ###"
echo "################################################################################"
sleep 2
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si   --noconfirm --needed
cd ..
rm yay -R -f

clear
echo "################################################################################"
echo "### Installing Needed packages                                               ###"
echo "################################################################################"

sudo pacman -S   --noconfirm --needed - < packages-repository.txt

clear
echo "################################################################################"
echo "### Setting Up Sound                                                         ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed pulseaudio
sudo pacman -S   --noconfirm --needed pulseaudio-alsa
sudo pacman -S   --noconfirm --needed pavucontrol
sudo pacman -S   --noconfirm --needed alsa-utils
sudo pacman -S   --noconfirm --needed alsa-plugins
sudo pacman -S   --noconfirm --needed alsa-lib
sudo pacman -S   --noconfirm --needed alsa-firmware
sudo pacman -S   --noconfirm --needed lib32-alsa-lib
sudo pacman -S   --noconfirm --needed lib32-alsa-oss
sudo pacman -S   --noconfirm --needed lib32-alsa-plugins
sudo pacman -S   --noconfirm --needed gstreamer
sudo pacman -S   --noconfirm --needed gst-plugins-good
sudo pacman -S   --noconfirm --needed gst-plugins-bad
sudo pacman -S   --noconfirm --needed gst-plugins-base
sudo pacman -S   --noconfirm --needed gst-plugins-ugly
sudo pacman -S   --noconfirm --needed playerctl

clear
echo "################################################################################"
echo "### Installing And Setting Up Bluetooth                                      ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed pulseaudio-bluetooth
sudo pacman -S   --noconfirm --needed bluez
sudo pacman -S   --noconfirm --needed bluez-libs
sudo pacman -S   --noconfirm --needed bluez-utils
sudo pacman -S   --noconfirm --needed bluez-plugins
sudo pacman -S   --noconfirm --needed blueberry
sudo pacman -S   --noconfirm --needed bluez-tools
sudo pacman -S   --noconfirm --needed bluez-cups
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

clear
echo "################################################################################"
echo "### Install XORG Display                                                     ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed xorg
sudo pacman -S   --noconfirm --needed xorg-drivers
sudo pacman -S   --noconfirm --needed xorg-xinit
sudo pacman -S   --noconfirm --needed xterm

clear
echo "################################################################################"
echo "### Installing The LightDM Login Manager                                     ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target

################################################################################
### Install nVidia Video Drivers                                             ###
################################################################################
function NVIDIA_DRIVERS() {
  clear
  echo "################################################################################"
  echo "### Installing nVidia Video Drivers                                          ###"
  echo "################################################################################"
  sleep 2
  sudo pacman -S   --noconfirm --needed nvidia
  sudo pacman -S   --noconfirm --needed nvidia-cg-toolkit
  sudo pacman -S   --noconfirm --needed nvidia-settings
  sudo pacman -S   --noconfirm --needed nvidia-utils
  sudo pacman -S   --noconfirm --needed lib32-nvidia-cg-toolkit
  sudo pacman -S   --noconfirm --needed lib32-nvidia-utils
  sudo pacman -S   --noconfirm --needed lib32-opencl-nvidia
  sudo pacman -S   --noconfirm --needed opencl-nvidia
  sudo pacman -S   --noconfirm --needed cuda
  sudo pacman -S   --noconfirm --needed ffnvcodec-headers
  sudo pacman -S   --noconfirm --needed lib32-libvdpau
  sudo pacman -S   --noconfirm --needed libxnvctrl
  sudo pacman -S   --noconfirm --needed pycuda-headers
  sudo pacman -S   --noconfirm --needed python-pycuda
  sudo pacman -R  xf86-video-nouveau
}
################################################################################
### Install AMD Video Drivers                                                ###
################################################################################
function AMD_DRIVERS() {
  clear
  echo "################################################################################"
  echo "### Installing AMD Video Drivers                                             ###"
  echo "################################################################################"
  sleep 2
  #$ZB -S   --noconfirm --needed amdgpu-pro-libgl
  #$ZB -S   --noconfirm --needed lib32-amdgpu-pro-libgl
  #$ZB -S   --noconfirm --needed amdvlk
  #$ZB -S   --noconfirm --needed lib32-amdvlk
  $ZB -S   --noconfirm --needed opencl-amd
  echo "##############################################################################"
  echo "### Congrats On Supporting Open Source GPU Vendor                          ###"
  echo "##############################################################################"
}

if [[ $(lspci -k | grep VGA | grep -i nvidia) ]]; then
  NVIDIA_DRIVERS
fi

if [[ $(lspci -k | grep VGA | grep -i amd) ]]; then
  AMD_DRIVERS
fi

# System tools
yay -S autotiling   --noconfirm --needed
yay -S qt5-styleplugins   --noconfirm --needed

# Internet
yay -S mailspring   --noconfirm --needed

# Theming
yay -S dracula-gtk-theme   --noconfirm --needed

git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme
chmod +x *.sh
sh ./install.sh purple
cd ..
rm Tela-icon-theme -R -f


cp -R .config/* ~/.config/
cp -R .gtkrc-2.0 ~/.gtkrc-2.0
sudo cp -R lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf
chmod -R +x ~/.config/i3/scripts 
dbus-launch dconf load / < xed.dconf
echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile

sudo pacman -Rsn $(pacman -Qdtq) --noconfirm

clear
echo "##############################################################################"
echo "### Installation Is Complete, Please Reboot And Have Fun                   ###"
echo "##############################################################################"
