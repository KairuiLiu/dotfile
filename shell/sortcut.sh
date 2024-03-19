alias gitBKCS="cd /home/liukairui/CODE/code-segments && git add . && git commit -m $(date '+UpDate_%Y-%m-%d_%H:%M') && git push"
alias mwin="/home/liukairui/FileTrans/.shell/mountWin.sh "
alias killwx="kill -SIGTERM -- -$(ps x -o "%r %c" | awk '{ n=substr($0,index($0,$2)); if(n~/uos/){print $1;exit} }')"
alias weatherUoA="curl zh.wttr.in/Grafton%20Auckland"
alias rr="ranger"
alias csp="cd /home/liukairui/CODE/code-segments"
alias rstudio="/usr/lib/rstudio/rstudio"
alias google-chrome-beta-wayland="/usr/bin/google-chrome-beta --gtk-version=4"
alias google-chrome-unstable-wayland="/usr/bin/google-chrome-unstable --gtk-version=4"
alias rstudio-wayland="rstudio --gtk-version=3 --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias code-insiders-wayland="code-insiders --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias android-studio-wayland="QT_QPA_PLATFORM=xcb android-studio"
alias aur-backup="cd ~/.dotfile/aur && ./backup.sh ./app-list.yaml"
alias aur-build="cd ~/.dotfile/aur && ./build-db.sh ./app-list.yaml"
alias aur-query="cd ~/.dotfile/aur && ./query.sh ./app-list.db"

alias git-proxy="git config --global https.proxy http://127.0.0.1:37179 ; git config --global http.proxy http://127.0.0.1:37179"
alias git-unproxy="git config --global --unset http.proxy ; git config --global --unset https.proxy"

function cli-proxy() {
    export http_proxy=http://127.0.0.1:37179
    export https_proxy=$http_proxy
    echo -e "proxy on"
}

function cli-unproxy() {
    unset http_proxy https_proxy
    echo -e "proxy off"
}
