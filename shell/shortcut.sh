alias weatherHD="curl zh.wttr.in/Beijing%20Haidian"
alias rr="/opt/homebrew/bin/im-select com.apple.keylayout.ABC ; ranger"
alias fzfh="FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob \"!.git/*\" --glob \"!.node_modules/*\"' fzf"
alias cp="cp -i"
alias ex="extract"
alias df='df -h'
alias python='python3'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias chrome-dev='/Applications/Google\ Chrome\ Dev.app/Contents/MacOS/Google\ Chrome\ Dev'
alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias krita='/Applications/krita.app/Contents/MacOS/krita'
alias more='less'
alias pnpx='pnpm --dlx '
alias k='~/code/k/k.bash'
alias pdm_cli='~/Public/PDM/pdm_cli'
alias mkdir='mkdir -p'
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

source ~/.dotfile/keep_local/source.sh

function ross() {
    if [ -f "./install/setup.zsh" ]; then
        source "./install/setup.zsh"
        echo "Sourced ./install/setup.zsh"
    else
        echo "No ./install/setup.zsh found in current directory"
    fi
}

afplay() {
    local args=("$@")
    command afplay -v 0.1 "${args[@]/#-v*/}"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
