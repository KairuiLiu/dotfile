#!/bin/bash

source "$HOME/.dotfile/shell/env.sh"
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

exec sway
