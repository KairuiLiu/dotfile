# DotFile

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

```bash
cd aur
./backup.sh ./app-list.yaml
```

**Existing Bugs**

- Fcitx: focus point and the candidate box are not on the same screen in Chrome.
- wofi: fcitx5 will flash on wofi.
- sway: inhibit_fullscreen not support
- ranger: image can not preview (in sway + alacritty)
- Vars
  - chrome:
    - `--gtk-version=4` to enable fcitx [Will Fix in Chrome 124]
    - `--ozone-platform=wayland` to force chrome running on wayland
  - vscode
    - `--enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland`: to force working on wayland
  - android-studio
    - `QT_QPA_PLATFORM=xcb`: Enable Android Emulator
