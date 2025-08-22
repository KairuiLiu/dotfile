# Arch Linux to Ubuntu Migration Guide

This guide helps you migrate your Arch Linux dotfiles to Ubuntu.

## Quick Start

1. **Install Ubuntu packages:**
   ```bash
   cd ~/.dotfile/aur
   chmod +x install-ubuntu.sh backup-ubuntu.sh query-ubuntu.sh
   ./install-ubuntu.sh ./app-list-ubuntu.yaml
   ```

2. **Update shell configuration:**
   - The `shell/env.sh` has been updated with Ubuntu-compatible paths
   - The `shell/shortcut.sh` now includes Ubuntu package management aliases

3. **Update system scripts:**
   - Use `checkupdates-ubuntu` instead of the original `checkupdates`
   - The `lupdates` script now uses `gnome-terminal` and `apt`

## Key Changes

### Package Management
- **Arch:** `pacman`, `yay`, AUR
- **Ubuntu:** `apt`, `snap`, `flatpak`

### New Scripts
- `aur/app-list-ubuntu.yaml` - Ubuntu package list
- `aur/install-ubuntu.sh` - Install packages from the list
- `aur/backup-ubuntu.sh` - Backup installed packages
- `aur/query-ubuntu.sh` - Query package information
- `i3wm/polybar/scripts/checkupdates-ubuntu` - Check for updates

### New Aliases
```bash
apt-backup       # Backup installed packages
apt-query        # Query package information  
apt-update       # Update system packages
apt-search       # Search for packages
snap-list        # List snap packages
flatpak-list     # List flatpak packages
```

### Path Updates
- Removed hardcoded `/home/liukairui/` paths
- Used `$HOME` for portability
- Updated Android SDK path to standard Ubuntu location
- Updated Flutter path for snap installation

## Manual Installation Required

Some packages need manual installation:

### Browsers
- **Google Chrome:** Download .deb from [google.com/chrome](https://www.google.com/chrome/)
- **Microsoft Edge:** Download .deb from [microsoft.com/edge](https://www.microsoft.com/edge/)

### Development Tools
- **JetBrains IDEs:** Download from [jetbrains.com](https://www.jetbrains.com/)
- **VS Code Insiders:** Download from [code.visualstudio.com/insiders](https://code.visualstudio.com/insiders/)

### Via Snap
```bash
sudo snap install flutter --classic
sudo snap install code --classic
sudo snap install discord
sudo snap install obs-studio
```

### Via Flatpak
```bash
flatpak install flathub com.obsproject.Studio
flatpak install flathub org.gimp.GIMP
flatpak install flathub com.discordapp.Discord
```

### PPAs for Additional Software
Some software may require adding PPAs:

```bash
# Polybar (if not in repositories)
sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt update
sudo apt install polybar

# Latest Git
sudo add-apt-repository ppa:git-core/ppa

# Wine
sudo apt install wine-staging
```

## Terminal Emulator Changes

- **Arch:** Used `termite` (no longer maintained)
- **Ubuntu:** Scripts updated to use `gnome-terminal` (default)

You can also install alternative terminals:
```bash
sudo apt install alacritty kitty foot
```

## Input Method (fcitx5)

fcitx5 is available in Ubuntu repositories:
```bash
sudo apt install fcitx5 fcitx5-chinese-addons fcitx5-config-qt
```

## Desktop Environment Support

The configuration supports both i3wm and Sway:

- **i3wm:** Available in Ubuntu repositories
- **Sway:** Available in Ubuntu repositories  
- **Polybar:** May need PPA or manual compilation

## Troubleshooting

### Missing Packages
If a package is not found:
1. Search for alternatives: `apt search package-name`
2. Check if available via snap: `snap find package-name`
3. Check if available via flatpak: `flatpak search package-name`

### Permission Issues
If you get permission errors:
```bash
sudo usermod -aG sudo $USER  # Add user to sudo group
newgrp sudo                  # Apply group changes
```

### Font Issues
Ubuntu includes most fonts, but you may need:
```bash
sudo apt install fonts-noto-cjk fonts-font-awesome
```

## Verification

After migration, verify your setup:
```bash
# Check installed packages
apt-backup

# Test aliases
apt-search neovim
snap-list
flatpak-list

# Check updates
/path/to/checkupdates-ubuntu
```

## Backup Original Files

Before applying changes, backup your original Arch configuration:
```bash
cp -r ~/.dotfile ~/.dotfile-arch-backup
```

This ensures you can revert if needed.