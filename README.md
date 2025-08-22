# DotFile

**Target Device & System:**
- **Device**: ASUS ZenBook UX3404VA (ZenBook 14X)
- **OS**: Arch Linux x86_64
- **Use Case**: Development laptop with dual X11/Wayland desktop environment support

**Environment:**

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

**Hardware Specifications:**
- **CPU**: 13th Gen Intel i9-13900H (20 cores) @ 5.200GHz
- **GPU**: Intel Raptor Lake-P [Iris Xe Graphics] 
- **Memory**: 32GB RAM
- **Display**: 2880x1800 resolution
- **Host**: Zenbook UX3404VA_UX3404VA 1.0

**Desktop Environments:**
- **Primary**: Sway (Wayland) with Waybar, Wofi, Mako
- **Secondary**: i3 (X11) with Polybar, Rofi, Dunst

**Config Files For:**

- Package backup
- fcitx5 (Chinese input method)
- x.org (X11 support)
- picom (compositor)
- i3 (X11 window manager)
  - polybar (status bar)
  - rofi (application launcher)
  - dunst (notifications)
  - touchegg (touchpad gestures)
- sway (Wayland window manager)
  - waybar (status bar)
  - wofi (application launcher)
  - mako (notifications)
- alacritty (terminal emulator)
- zsh (shell)
- ranger (file manager)
- clight (adaptive brightness)
- mpd (music player daemon)
- vim (text editor)
- howdy (facial recognition login)

**Generate Difference of Backup List & System Package**

```bash
cd aur
./backup.sh ./app-list.yaml
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
