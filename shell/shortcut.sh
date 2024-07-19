alias gitBKCS="cd /home/liukairui/CODE/code-segments && git add . && git commit -m $(date '+UpDate_%Y-%m-%d_%H:%M') && git push"
alias mwin="/home/liukairui/fileTrans/mountWin.sh "
alias killwx="kill -SIGTERM -- -$(ps x -o "%r %c" | awk '{ n=substr($0,index($0,$2)); if(n~/uos/){print $1;exit} }')"
alias weatherUoA="curl zh.wttr.in/Grafton%20Auckland"
alias rr="ranger"
alias csp="cd /home/liukairui/CODE/code-segments"
alias rstudio="/usr/lib/rstudio/rstudio"
alias google-chrome-beta-wayland="LD_PRELOAD=/usr/lib/libgtk-4.so google-chrome-beta --ozone-platform=wayland --gtk-version=4"
alias google-chrome-unstable-wayland="LD_PRELOAD=/usr/lib/libgtk-4.so google-chrome-unstable --ozone-platform=wayland --gtk-version=4"
alias rstudio-wayland="rstudio --gtk-version=3 --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias code-insiders-wayland="code-insiders --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias android-studio-wayland="QT_QPA_PLATFORM=xcb android-studio"
alias aur-backup="cd ~/.dotfile/aur && ./backup.sh ./app-list.yaml"
alias aur-build="cd ~/.dotfile/aur && ./build-db.sh ./app-list.yaml"
alias aur-query="cd ~/.dotfile/aur && ./query.sh ./app-list.db"
alias ra="ranger"
alias fzfh="FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob \"!.git/*\" --glob \"!.node_modules/*\"' fzf"
alias cp="cp -i"     # confirm before overwriting something
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

alias git-proxy="git config --global https.proxy http://127.0.0.1:37179 ; git config --global http.proxy http://127.0.0.1:37179"
alias git-unproxy="git config --global --unset http.proxy ; git config --global --unset https.proxy"

function cli-proxy() {
    export http_proxy=http://127.0.0.1:37179
    export https_proxy=$http_proxy
    export socks_proxy=socks5://127.0.0.1:37179
    echo -e "HTTP & WS Proxy on"
}

function cli-unproxy() {
    unset http_proxy
    unset https_proxy
    unset socks_proxy
    echo -e "HTTP & WS Proxy off"
}

function ross() {
    if [ -f "./install/setup.zsh" ]; then
        source "./install/setup.zsh"
        echo "Sourced ./install/setup.zsh"
    else
        echo "No ./install/setup.zsh found in current directory"
    fi
}

ex() {
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
