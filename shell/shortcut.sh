alias weatherUoA="curl zh.wttr.in/Beijing%20Haidian"
alias rr="/opt/homebrew/bin/im-select com.apple.keylayout.ABC ; ranger"
alias fzfh="FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob \"!.git/*\" --glob \"!.node_modules/*\"' fzf"
alias cp="cp -i"
alias df='df -h'
alias free='free -m'
alias np='nano -w PKGBUILD'
alias python='python3'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias chrome-dev='/Applications/Google\ Chrome\ Dev.app/Contents/MacOS/Google\ Chrome\ Dev'
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias krita='/Applications/krita.app/Contents/MacOS/krita'
alias more=less
alias cat='ccat'
alias top='gtop'

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
