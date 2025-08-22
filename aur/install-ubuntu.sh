#!/bin/bash

# Ubuntu Package Installer Script
# Installs packages from the Ubuntu package list

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-app-list-ubuntu.yaml>"
    exit 1
fi

APP_LIST_PATH="$1"

if [[ ! -f "$APP_LIST_PATH" ]]; then
    echo "Error: File $APP_LIST_PATH not found"
    exit 1
fi

# Parse packages from YAML file
parsePackages() {
    local packages=()
    while IFS= read -r line; do
        if [[ "$line" == \#* ]] || [[ -z "$line" ]] || [[ "$line" == *":" ]]; then
            continue
        fi
        local package_name=$(echo "$line" | sed -e 's/^[[:space:]]*-\{1\}[[:space:]]*//' -e 's/\/\/.*//' -e 's/[[:space:]]*$//')
        
        # Skip empty lines and special instructions
        if [[ -n "$package_name" ]] && [[ "$package_name" != *"install via"* ]] && [[ "$package_name" != *"via ppa"* ]]; then
            packages+=("$package_name")
        fi
    done < "$APP_LIST_PATH"
    echo "${packages[@]}"
}

# Function to install APT packages
install_apt_packages() {
    local packages=("$@")
    local failed_packages=()
    
    echo "=== Installing APT packages ==="
    sudo apt update
    
    for package in "${packages[@]}"; do
        echo "Installing: $package"
        if ! sudo apt install -y "$package"; then
            echo "Failed to install: $package"
            failed_packages+=("$package")
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        echo "=== Failed APT packages ==="
        printf '%s\n' "${failed_packages[@]}"
    fi
}

# Function to install Snap packages (common ones)
install_snap_packages() {
    echo "=== Installing common Snap packages ==="
    
    # Common snap packages that might be in the list
    local snap_packages=(
        "flutter --classic"
        "code --classic"
        "discord"
        "obs-studio"
        "vlc"
    )
    
    for snap_pkg in "${snap_packages[@]}"; do
        echo "Installing snap: $snap_pkg"
        if ! sudo snap install $snap_pkg; then
            echo "Failed to install snap: $snap_pkg"
        fi
    done
}

# Function to install Flatpak packages
install_flatpak_packages() {
    echo "=== Setting up Flatpak ==="
    
    # Add flathub repository
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Common flatpak packages
    local flatpak_packages=(
        "com.obsproject.Studio"
        "org.gimp.GIMP"
        "org.libreoffice.LibreOffice"
        "com.discordapp.Discord"
    )
    
    for flatpak_pkg in "${flatpak_packages[@]}"; do
        echo "Installing flatpak: $flatpak_pkg"
        if ! sudo flatpak install -y flathub "$flatpak_pkg"; then
            echo "Failed to install flatpak: $flatpak_pkg"
        fi
    done
}

# Main installation process
main() {
    echo "Starting Ubuntu package installation..."
    echo "Package list: $APP_LIST_PATH"
    
    # Parse packages from the YAML file
    readarray -t packages <<< "$(parsePackages)"
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "No packages found in the list"
        exit 1
    fi
    
    echo "Found ${#packages[@]} packages to install"
    
    # Install APT packages
    install_apt_packages "${packages[@]}"
    
    # Install Snap packages
    install_snap_packages
    
    # Install Flatpak packages
    install_flatpak_packages
    
    echo "=== Installation completed ==="
    echo "Some packages may require manual installation:"
    echo "- Google Chrome: Download .deb from google.com"
    echo "- Microsoft Edge: Download .deb from microsoft.com"
    echo "- JetBrains IDEs: Download from jetbrains.com"
    echo "- Some development tools may need PPAs or manual compilation"
}

main