#!/usr/bin/env bash

# shellcheck source=$HOME/.local/bin/hyde-shell
# shellcheck disable=SC1091
if ! source "$(which hyde-shell)"; then
    echo "[wallbash] code :: Error: hyde-shell not found."
    echo "[wallbash] code :: Is HyDE installed?"
    exit 1
fi

confDir="${confDir:-$HOME/.config}"
gtkIcon="${gtkIcon:-Tela-circle-dracula}"
iconsDir="${iconsDir:-$XDG_DATA_HOME/icons}"
cacheDir="${cacheDir:-$XDG_CACHE_HOME/hyde}"
WALLBASH_SCRIPTS="${WALLBASH_SCRIPTS:-$hydeConfDir/wallbash/scripts}"
hypr_border=10
dunstDir="${confDir}/dunst"
allIcons=$(find "${XDG_DATA_HOME:-$HOME/.local/share}/icons" -mindepth 1 -maxdepth 2 -name "icon-theme.cache" -print0 | xargs -0 -n1 dirname | xargs -n1 basename | paste -sd, -)

# Set font name
font_name=${DUNST_FONT}
font_name=${font_name:-$(get_hyprConf "DUNST_FONT")}
font_name=${font_name:-$(get_hyprConf "FONT")}

cat <<WARN >"${dunstDir}/dunstrc"
# WARNING: This file is auto-generated by '${WALLBASH_SCRIPTS}/dunst.sh'.
# DO NOT edit manually.
# For user configuration edit '${confDir}/dunst/dunst.conf' then run 'hyde-shell wallbash dunst' to apply changes.
# Updated dunst configuration: https://github.com/HyDE-Project/HyDE/blob/master/Configs/.config/dunst/dunst.conf

# HyDE specific section // To override the default configuration edit '${cacheDir}/wallbash/dunst.conf'
# ------------------------------------------------------------------------------
[global]
corner_radius = ${hypr_border}
icon_corner_radius = ${hypr_border}
dmenu = $(which rofi) -config notification -dmenu -p dunst:
icon_theme = "${gtkIcon},${allIcons}"


# [Type-1]
# appname = "t1"
# format = "<b>%s</b>"

# [Type-2]
# appname = "HyDE Notify"
# format = "<span size="250%">%s</span>\n%b"

[Type-1]
appname = "HyDE Alert"
format = "<b>%s</b>"

[Type-2]
appname = "HyDE Notify"
format = "<span size="250%">%s</span>\n%b"



[urgency_critical]
background = "#f5e0dc"
foreground = "#1e1e2e"
frame_color = "#f38ba8"
icon = "${iconsDir}/Wallbash-Icon/critical.svg"
timeout = 0

# ------------------------------------------------------------------------------

WARN

# For Clarity We added a warning and remove comments and empty lines for the auto-generated file
grep -v '^\s*#' "${dunstDir}/dunst.conf" | grep -v '^\s*$' | envsubst >>"${dunstDir}/dunstrc"

cat <<MANDATORY >>"${dunstDir}/dunstrc"
# HyDE Mandatory section // Non overridable // please open a request in https://github.com/HyDE-Project/HyDE
# ------------------------------------------------------------------------------
[global]

font = ${font_name} 8
dmenu = $(which rofi) -config notification -dmenu -p dunst:


# Wallbash section
# ------------------------------------------------------------------------------

MANDATORY

mkdir -p "${cacheDir}/wallbash"
envsubst <"${cacheDir}/wallbash/dunst.conf" >>"${dunstDir}/dunstrc"
killall dunst
dunst &
