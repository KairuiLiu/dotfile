# Global Proxy Setting
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''

# Language Location and Input Setting
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_MONETARY=en_NZ.UTF-8
export LC_TIME=en_NZ.UTF-8
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export GLFW_IM_MODULE=fcitx
export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx
export IMSETTINGS_MODULE=fcitx
export SDL_IM_MODULE=fcitx

# Path Setting
export PATH=/usr/local/texlive/2023/bin/x86_64-linux:/home/liukairui/.local/bin:$PATH
export MANPATH=/usr/local/texlive/2023/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2023/texmf-dist/doc/info:$INFOPATH

# Flutter and Android Setting
export PATH=/opt/flutter/bin:$PATH
export CHROME_EXECUTABLE="/usr/bin/google-chrome-beta"
export ANDROID_HOME="/home/liukairui/.andriodHome/Sdk"
export ANDROID_SDK_ROOT='/home/liukairui/.andriodHome/Sdk'
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# Wayland Setting
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=qt5ct

export GTK2_RC_FILES=/etc/gtk-2.0/gtkrc:/home/liukairui/.gtkrc-2.0:/home/liukairui/.config/gtkrc-2.0
export GTK_RC_FILES=/etc/gtk/gtkrc:/home/liukairui/.gtkrc:/home/liukairui/.config/gtkrc
export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*" --glob "!.node_modules"'

export GOPATH=~/.go
export R_LIBS_USER=~/.R
