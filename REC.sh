#!/bin/bash

if [[ $(id -u) = 0 ]]
then
        echo "Please do NOT run the recovery script as root"
        exit 1
fi

echo "RECOVERY START\n"
ln -s ~/.dotfile/vimrc ~/.vimrc
ln -s ~/.dotfile/asoundrc ~/.asoundrc
ln -s ~/.dotfile/Xmodmap ~/.Xmodmap
ln -s ~/.dotfile/xprofile ~/.xprofile
ln -s ~/.dotfile/mpdconf ~/.mpdconf
ln -s ~/.dotfile/Xresources ~/.Xresources
ln -s ~/.dotfile/bashrc ~/.bashrc
ln -s ~/.dotfile/zshrc ~/.zshrc
ln -s ~/.dotfile/p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfile/face ~/.face
ln -s ~/.dotfile/i3_config ~/.config/i3/config
ln -s ~/.dotfile/fcitx5_config_pinyin.conf ~/.config/fcitx5/conf/pinyin.conf
ln -s ~/.dotfile/fcitx5_config ~/.config/fcitx5/config
ln -s ~/.dotfile/ranger ~/.config/ranger
ln -s ~/.dotfile/polybar ~/.config/polybar
ln -s ~/.dotfile/picom ~/.config/picom  
ln -s ~/.dotfile/pam_environment ~/.pam_environment 
ln -s ~/.dotfile/touchegg.conf ~/.config/touchegg
sudo cp ~/.dotfile/asus* /usr/lib/systemd/system/
sudo cp -r ~/.dotfile/asus_touchpad_numpad-driver /usr/share
sudo ln -s /usr/lib/systemd/system/asus_touchpad_numpad_st.service /etc/systemd/system/default.target.wants/asus_touchpad_numpad_st.service
sudo cp ~/.dotfile/archlinuxcn-mirrorlist /etc/pacman.d/archlinuxcn-mirrorlist
echo "add to /etc/pacman.conf :\n[archlinuxcn]\nInclude = /etc/pacman.d/archlinuxcn-mirrorlist\n"

echo "RECOVERY END\n"
echo "CHOOSE TO RUN\n"
echo "cp ~/.dotfile/pacman.conf /etc/pacman.conf\n"
echo "sudo pacman -S < pacman_user_install\n"
echo "yay -S < yay_user_install\n"
echo "sudo pacman -S < pacman_user_install_min\n"
echo "yay -S < yay_user_install_min\n"