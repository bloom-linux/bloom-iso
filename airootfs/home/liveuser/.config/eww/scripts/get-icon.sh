#!/usr/bin/env bash
# Returns a Nerd Font icon for the given window class name
class="${1,,}"  # lowercase
case "$class" in
    kitty|foot|alacritty|wezterm|xterm|urxvt) echo "" ;;
    firefox|firefox-esr)                       echo "󰈹" ;;
    chromium|chromium-browser)                 echo "" ;;
    brave-browser|brave)                       echo "" ;;
    google-chrome*)                            echo "" ;;
    thunar|nemo|nautilus|pcmanfm)              echo "󰉋" ;;
    code|code-oss|codium|vscodium)             echo "󰨞" ;;
    nvim|neovim|vim)                           echo "" ;;
    mousepad|gedit|kate|notepadqq)             echo "󰏬" ;;
    mpv)                                       echo "" ;;
    vlc)                                       echo "󰕼" ;;
    spotify)                                   echo "󰓇" ;;
    rhythmbox|lollypop|amberol)                echo "󰓃" ;;
    discord)                                   echo "󰙯" ;;
    telegram-desktop|telegramdesktop)          echo "" ;;
    signal)                                    echo "󰭹" ;;
    steam)                                     echo "󰓓" ;;
    gimp|gimp-2.*)                             echo "" ;;
    inkscape)                                  echo "󰺩" ;;
    obs|obs-studio)                            echo "" ;;
    libreoffice*)                              echo "󰈙" ;;
    evince|okular|zathura)                     echo "󰈦" ;;
    eog|gwenview|shotwell)                     echo "󰋩" ;;
    rofi)                                      echo "❀" ;;
    *)                                         echo "" ;;
esac
