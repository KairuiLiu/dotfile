# DotFile

**Multi-Distribution Support:**

This dotfile configuration now supports both **Arch Linux** and **Ubuntu**.

**Environment (Original Arch Linux):**

```
                   -`                    liukairui@KarryZenBook14X
                  .o+`                   -------------------------
                 `ooo/                   OS: Arch Linux x86_64
                `+oooo:                  Host: Zenbook UX3404VA_UX3404VA 1.0
               `+oooooo:                 Kernel: 6.8.1-arch1-1
               -+oooooo+:                Uptime: 4 mins
             `/:-:++oooo+:               Packages: 2788 (pacman)
            `/++++/+++++++:              Shell: zsh 5.9
           `/++++++++++++++:             Resolution: 2880x1800
          `/+++ooooooooooooo/`           WM: sway
         ./ooosssso++osssssso+`          Theme: Breeze [GTK2/3]
        .oossssso-````/ossssss+`         Icons: Tela-circle-blue-dark [GTK2/3]
       -osssssso.      :ssssssso.        Terminal: alacritty
      :osssssss/        osssso+++.       CPU: 13th Gen Intel i9-13900H (20) @ 5.200GHz
     /ossssssss/        +ssssooo/-       GPU: Intel Raptor Lake-P [Iris Xe Graphics]
   `/ossssso+/:-        -:/+osssso+-     Memory: 2277MiB / 31711MiB
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
```

## Quick Setup

### Auto-detect and configure:
```bash
./configure.sh detect
```

### Manual configuration:
```bash
# For Arch Linux
./configure.sh arch

# For Ubuntu
./configure.sh ubuntu
```

### Ubuntu Migration
For detailed Ubuntu migration instructions, see [UBUNTU_MIGRATION.md](UBUNTU_MIGRATION.md).

**Config Files For:**

- Package backup
- fcitx5
- x.org
- picom
- i3
  - polybar
  - rofi
  - dunst
  - touchegg
- sway
  - waybar
  - wofi
  - mako
- alactitty
- zsh
- ranger
- clight
- mpd
- vim
- howdy

**Generate Difference of Backup List & System Package**

Arch Linux:
```bash
cd aur
./backup.sh ./app-list.yaml
```

Ubuntu:
```bash
cd aur
./backup-ubuntu.sh ./app-list-ubuntu.yaml
```

**Install Packages**

Arch Linux (original):
```bash
# Manual installation required - see app-list.yaml
```

Ubuntu:
```bash
cd aur
./install-ubuntu.sh ./app-list-ubuntu.yaml
```

**Existing Bugs**

- Fcitx: focus point and the candidate box are not on the same screen in Chrome.
- wofi: fcitx5 will flash on wofi.
- sway: inhibit_fullscreen not support
- Vars
  - chrome:
    - `--gtk-version=4` to enable fcitx5
    - `--ozone-platform=wayland` to force chrome running on wayland
  - vscode
    - `--enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland`: to force working on wayland
  - android-studio
    - `QT_QPA_PLATFORM=xcb`: Enable Android Emulator
