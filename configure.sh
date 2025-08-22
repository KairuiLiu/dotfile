#!/bin/bash

# Dotfile Configuration Switcher
# Switches between Arch Linux and Ubuntu configurations

set -e

DOTFILE_DIR="$HOME/.dotfile"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}    Dotfile Configuration Switcher${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo
}

print_usage() {
    echo "Usage: $0 [arch|ubuntu|detect]"
    echo
    echo "Options:"
    echo "  arch     - Configure for Arch Linux"
    echo "  ubuntu   - Configure for Ubuntu"
    echo "  detect   - Auto-detect current system"
    echo
    echo "Examples:"
    echo "  $0 ubuntu    # Switch to Ubuntu configuration"
    echo "  $0 detect    # Auto-detect and configure"
}

detect_system() {
    if [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release; then
        echo "ubuntu"
    elif [ -f /etc/os-release ] && grep -q "Ubuntu" /etc/os-release; then
        echo "ubuntu"
    elif command -v pacman &> /dev/null; then
        echo "arch"
    elif command -v apt &> /dev/null; then
        echo "ubuntu"
    else
        echo "unknown"
    fi
}

configure_arch() {
    echo -e "${GREEN}Configuring for Arch Linux...${NC}"
    
    # Update shortcuts to use Arch aliases
    if [ -f "$DOTFILE_DIR/shell/shortcut.sh" ]; then
        # Comment out Ubuntu aliases and uncomment Arch aliases
        sed -i 's/^alias aur-/# alias aur-/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias aur-backup=/alias aur-backup=/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias aur-build=/alias aur-build=/' "$DOTFILE_DIR/shell/shortcut.sh" 
        sed -i 's/^# alias aur-query=/alias aur-query=/' "$DOTFILE_DIR/shell/shortcut.sh"
        
        # Comment out Ubuntu-specific aliases
        sed -i 's/^alias apt-/# alias apt-/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^alias snap-/# alias snap-/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^alias flatpak-/# alias flatpak-/' "$DOTFILE_DIR/shell/shortcut.sh"
    fi
    
    # Use original update scripts
    if [ -f "$DOTFILE_DIR/i3wm/polybar/scripts/checkupdates" ]; then
        ln -sf checkupdates "$DOTFILE_DIR/i3wm/polybar/scripts/checkupdates-active"
    fi
    
    echo -e "${GREEN}✓ Configured for Arch Linux${NC}"
    echo -e "${YELLOW}  Primary package manager: pacman/yay${NC}"
    echo -e "${YELLOW}  Package list: aur/app-list.yaml${NC}"
}

configure_ubuntu() {
    echo -e "${GREEN}Configuring for Ubuntu...${NC}"
    
    # Update shortcuts to use Ubuntu aliases
    if [ -f "$DOTFILE_DIR/shell/shortcut.sh" ]; then
        # Comment out Arch aliases
        sed -i 's/^alias aur-/# alias aur-/' "$DOTFILE_DIR/shell/shortcut.sh"
        
        # Uncomment Ubuntu aliases if they're commented
        sed -i 's/^# alias apt-backup=/alias apt-backup=/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias apt-query=/alias apt-query=/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias apt-update=/alias apt-update=/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias snap-list=/alias snap-list=/' "$DOTFILE_DIR/shell/shortcut.sh"
        sed -i 's/^# alias flatpak-list=/alias flatpak-list=/' "$DOTFILE_DIR/shell/shortcut.sh"
    fi
    
    # Use Ubuntu update scripts
    if [ -f "$DOTFILE_DIR/i3wm/polybar/scripts/checkupdates-ubuntu" ]; then
        ln -sf checkupdates-ubuntu "$DOTFILE_DIR/i3wm/polybar/scripts/checkupdates-active"
    fi
    
    echo -e "${GREEN}✓ Configured for Ubuntu${NC}"
    echo -e "${YELLOW}  Primary package manager: apt${NC}"
    echo -e "${YELLOW}  Package list: aur/app-list-ubuntu.yaml${NC}"
    echo -e "${YELLOW}  Additional: snap, flatpak${NC}"
    echo
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Install packages: cd aur && ./install-ubuntu.sh ./app-list-ubuntu.yaml"
    echo -e "  2. See UBUNTU_MIGRATION.md for detailed instructions"
}

main() {
    print_header
    
    if [ $# -eq 0 ]; then
        print_usage
        exit 1
    fi
    
    case "$1" in
        "arch")
            configure_arch
            ;;
        "ubuntu")
            configure_ubuntu
            ;;
        "detect")
            SYSTEM=$(detect_system)
            echo -e "${BLUE}Detected system: ${SYSTEM}${NC}"
            echo
            case "$SYSTEM" in
                "arch")
                    configure_arch
                    ;;
                "ubuntu")
                    configure_ubuntu
                    ;;
                "unknown")
                    echo -e "${RED}Unable to detect system type${NC}"
                    echo "Please specify 'arch' or 'ubuntu' manually"
                    exit 1
                    ;;
            esac
            ;;
        "-h"|"--help")
            print_usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo
            print_usage
            exit 1
            ;;
    esac
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi