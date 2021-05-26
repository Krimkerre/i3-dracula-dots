#!/usr/bin/env bash

cp -R .config/* ~/.config/
cp -R .gtkrc-2.0 ~/.gtkrc-2.0
chmod -R +x ~/.config/i3/scripts 
dbus-launch dconf load / < xed.dconf
echo "export QT_QPA_PLATFORMTHEME=gtk2" >> ~/.profile
