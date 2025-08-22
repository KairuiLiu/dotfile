# Global Proxy Setting
export http_proxy=''
export https_proxy=''
export ftp_proxy=''
export socks_proxy=''

# Language Location and Input Setting
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
export LC_MONETARY=zh_CN.UTF-8
export LC_TIME=zh_CN.UTF-8
# export GTK_IM_MODULE=fcitx
export QT_IM_MODULE="wayland;fcitx;ibus"
export GLFW_IM_MODULE=fcitx
export INPUT_METHOD=fcitx
export XMODIFIERS=@im=fcitx
export IMSETTINGS_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GDK_BACKEND=wayland


# Path Setting - Use $HOME instead of hardcoded username for portability
export PATH=$HOME/.local/bin:$PATH
# For Ubuntu, texlive packages are typically in standard locations
# export PATH=/usr/bin:/usr/local/bin:$PATH
# export MANPATH=/usr/share/man:$MANPATH

# Flutter and Android Setting - Updated for Ubuntu paths
export PATH=/snap/flutter/current/bin:$PATH  # if installed via snap
# export PATH=/opt/flutter/bin:$PATH  # if installed manually
export CHROME_EXECUTABLE="/usr/bin/google-chrome"  # standard chrome path on Ubuntu
export ANDROID_HOME="$HOME/Android/Sdk"  # standard Android SDK path
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

# Wayland Setting
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER=1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORMTHEME=qt5ct

export GTK2_RC_FILES=/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0:$HOME/.config/gtkrc-2.0
export GTK_RC_FILES=/etc/gtk/gtkrc:$HOME/.gtkrc:$HOME/.config/gtkrc
export FZF_DEFAULT_COMMAND='rg --files --follow --glob "!.git/*" --glob "!.node_modules"'

export GOPATH=$HOME/.go
export R_LIBS_USER=$HOME/.R

export GEM_HOME="$HOME/.gems"
export GEM_PATH="$HOME/.gems"
