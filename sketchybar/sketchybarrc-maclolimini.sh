#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

FONT_FACE = "JetBrainsMonoNL Nerd Font"
PADDINGS = 3
PLUGINS_DIR = "$CONFIG_DIR/plugins_maclolimini"
SHARED_PLUGINS_DIR = "$CONFIG_DIR/plugins"

bar=(
    height=40
    color=#FF0000
    shadow=on
    position=top
    sticky=on
    padding_right=10
    padding_left=10
    corner_radius=12
    y_offset=0
    margin=10
    blur_radius=20
)

sketchybar --bar "${bar[@]}"

sketchybar --hotload on

sketchybar --update