#!/bin/bash

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_update_windows

declare -A monitors
while IFS=" " read -r monitor_id display_id; do
  monitors["$monitor_id"]="$display_id"
done < <(aerospace list-monitors --format '%{monitor-id} %{monitor-appkit-nsscreen-screens-id}')

for monitor_id in "${monitors[@]}"; do
  for sid in $(aerospace list-workspaces --monitor $monitor_id); do
    sketchybar --add item space.$sid left \
      --subscribe space.$sid aerospace_workspace_change \
      --set space.$sid \
        display=${monitors["$monitor_id"]}\
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=on \
        label="$sid" \
        label.width = 40 \
        label.font.size = 12.0 \ 
        click_script="aerospace workspace $sid" \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
  done
done


#sketchybar --add item current_space left \
#    --set current_space \
#    background.color=0xfff5a97f \
#    icon.color=0xff24273a \
#    label.drawing=off \
#    script="$PLUGIN_SHARED_DIR/current_space.sh" \
#    --subscribe current_space space_change mouse.clicked aerospace_workspace_change