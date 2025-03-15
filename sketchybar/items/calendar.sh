#!/usr/bin/env zsh

calendar=(
    width=150
    label.color=$LABEL_COLOR
    label.padding_left=5
    label.padding_right=5
    background.color=$BACKGROUND_1
    update_freq=30
    script="$SHARED_PLUGIN_DIR/calendar.sh"
)

calendar_logo=(
    icon=$CALENDAR  
    width=30
    icon.color=$BLACK
    label.padding_left=6
    align=center
    label.drawing=off
    background.height=$ITEM_BACKGROUND_HEIGHT 
    background.color=$SPACE_SELECTED
    background.corner_radius=$ITEM_CORNER_RADIUS
    padding_left=0
    padding_right=0
)

calendar_info=(
    background.color=$SPACE_DESELECTED
    background.corner_radius=$ITEM_CORNER_RADIUS
    background.height=$ITEM_BACKGROUND_HEIGHT
    background.padding_right=10
    background.padding_left=10
)

sketchybar --add item     calendar right               \
           --set calendar "${calendar[@]}"              \
           --subscribe    calendar system_woke

sketchybar --add item calendar_logo right \
           --set calendar_logo "${calendar_logo[@]}"

sketchybar --add bracket calendar_info calendar calendar_logo \
           --set calendar_info "${calendar_info[@]}