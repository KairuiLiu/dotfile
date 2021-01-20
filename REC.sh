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
echo "RECOVERY END\n"
echo "CHOOSE TO RUN\n"
echo "cp ~/.dotfile/pacman.conf /etc/pacman.conf\n"
echo "sudo pacman -S < pacman_user_install\n"
echo "yay -S < yay_user_install\n"
echo "yaourt -S < yaourt_user_install\n"
echo "sudo pacman -S < pacman_user_install_min\n"
echo "yay -S < yay_user_install_min\n"
echo "yaourt -S < yaourt_user_install_min\n"
