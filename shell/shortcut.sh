alias gitBKCS="cd /home/liukairui/CODE/code-segments && git add . && git commit -m $(date '+UpDate_%Y-%m-%d_%H:%M') && git push"
alias mwin="/home/liukairui/fileTrans/mountWin.sh "
alias rr="ranger"
alias csp="cd /home/liukairui/CODE/code-segments"
alias rstudio="/usr/lib/rstudio/rstudio"
alias rstudio-wayland="rstudio --gtk-version=3 --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias code-insiders-wayland="code-insiders --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias android-studio-wayland="QT_QPA_PLATFORM=xcb android-studio"
alias aur-backup="cd ~/.dotfile/aur && ./backup.sh ./app-list.yaml"
alias aur-build="cd ~/.dotfile/aur && ./build-db.sh ./app-list.yaml"
alias aur-query="cd ~/.dotfile/aur && ./query.sh ./app-list.db"
alias google-chrome-beta-wayland="LD_PRELOAD=/usr/lib/libgtk-4.so google-chrome-beta --ozone-platform=wayland --gtk-version=4"
alias google-chrome-unstable-wayland="google-chrome-unstable --enable-wayland-ime --wayland-text-input-version=3 --enable-feature=UseOzonPlatform --ozone-platform=wayland --enable-wayland-ime"
alias ra="ranger"
alias fzfh="FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob \"!.git/*\" --glob \"!.node_modules/*\"' fzf"
alias cp="cp -i"     # confirm before overwriting something
alias df='df -h'     # human-readable sizes
alias free='free -m' # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ex="extract"
alias pnpx='pnpm --dlx '
alias mkdir='mkdir -p'
alias claude='ipgatekeeper --country JP -- claude'

if [[ -o interactive ]]; then
    alias _ls='command ls'
    alias _ll='command ls -alh'
    alias ls='eza --color=auto'
    alias ll='eza -al --git --color=auto'
    alias _tree='command tree'
    alias tree='eza --tree'
    alias _grep='command grep'
    alias grep='rg'
    alias _find='command find'
    alias find='fd'
    alias _top='command top'
    alias top='btop'
    alias _du='command du -sh'
    alias du='dust'
    alias _diff='command diff'
    alias diff='delta'
    alias _ps='command ps'
    alias ps='procs'
    alias _ping='command ping'
    alias ping='gping'
fi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias git-proxy="git config --global https.proxy http://127.0.0.1:7897 ; git config --global http.proxy http://127.0.0.1:7897"
alias git-unproxy="git config --global --unset http.proxy ; git config --global --unset https.proxy"

function cli-proxy() {
    export http_proxy=http://127.0.0.1:7897
    export https_proxy=$http_proxy
    export socks_proxy=socks5://127.0.0.1:7897
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
