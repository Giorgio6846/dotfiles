#!/usr/bin/env zsh

sketchybar --add item volume right \
           --set volume script="$SHARED_PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \
