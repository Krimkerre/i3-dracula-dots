# Contains parts of i3 install script by Johannes Kamprad #
# https://github.com/endeavouros-team/i3-EndeavourOS #
# https://github.com/killajoe #

# Contains parts of Erik Sundquist's Arch install script #
# https://github.com/lotw69/arch-scripts #

# Modified for own use by Krim Kerre #
# https://github.com/Krimkerre #

#!/usr/bin/env bash

clear
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
echo "### Install XORG Display                                                     ###"
echo "################################################################################"
sleep 2

sudo pacman -S   --noconfirm --needed xorg-server
sudo pacman -S   --noconfirm --needed xorg-xbacklight
sudo pacman -S   --noconfirm --needed xorg-xdpyinfo
sudo pacman -S   --noconfirm --needed xorg-xinit
sudo pacman -S   --noconfirm --needed xorg-xinput
sudo pacman -S   --noconfirm --needed xorg-xkill
sudo pacman -S   --noconfirm --needed xorg-xrandr
sudo pacman -S   --noconfirm --needed xorg-xbacklight
sudo pacman -S   --noconfirm --needed xorg-xdpyinfo
sudo pacman -S   --noconfirm --needed xterm
sudo pacman -S   --noconfirm --needed xorg-drivers

clear
echo "################################################################################"
echo "### Setting Up Sound                                                         ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed - < packages-sound.txt

clear
echo "################################################################################"
echo "### Installing And Setting Up Bluetooth                                      ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed - < packages-bluetooth.txt

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

clear
echo "################################################################################"
echo "### Installing The LightDM Login Manager                                     ###"
echo "################################################################################"
sleep 2
sudo pacman -S   --noconfirm --needed lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
sudo systemctl enable lightdm.service -f
sudo systemctl set-default graphical.target
sudo cp -R lightdm-gtk-greeter.conf /etc/lightdm/lightdm-gtk-greeter.conf


################################################################################
### Install nVidia Video Drivers                                             ###
################################################################################
function NVIDIA_DRIVERS() {
  clear
  echo "################################################################################"
  echo "### Installing nVidia Video Drivers                                          ###"
  echo "################################################################################"
  sleep 2

  sudo pacman -S   --noconfirm --needed - < packages-nvidia.txt


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

  sudo pacman -S   --noconfirm --needed amdvlk
  sudo pacman -S   --noconfirm --needed lib32-amdvlk
  sudo pacman -S   --noconfirm --needed opencl-amd
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


clear
echo "################################################################################"
echo "### Installing AUR packages                                                  ###"
echo "################################################################################"

# System tools
yay -S autotiling   --noconfirm --needed
yay -S qt5-styleplugins   --noconfirm --needed
yay -S pfetch-git   --noconfirm --needed


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


sudo mkdir -p /etc/X11/xorg.conf.d && sudo tee <<'EOF' /etc/X11/xorg.conf.d/90-touchpad.conf 1> /dev/null
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection

EOF



clear
echo "################################################################################"
echo "### Installing i3-gaps and apps                                              ###"
echo "################################################################################"

sudo pacman -S   --noconfirm --needed - < packages-desktop.txt

cp -R .config/* ~/.config/
cp -R .gtkrc-2.0 ~/.gtkrc-2.0
chmod -R +x ~/.config/i3/scripts 
dbus-launch dconf load / < xed.dconf
echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile

pacman -Rsn $(pacman -Qdtq) --noconfirm

clear
echo "##############################################################################"
echo "### Installation Is Complete, Please Reboot And Have Fun                   ###"
echo "##############################################################################"
