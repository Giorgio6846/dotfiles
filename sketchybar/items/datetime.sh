#!/usr/bin/env bash

sketchybar -m --add       item               time             right                                        \
              --set       time               update_freq=2                                                 \
                                             icon.padding_right=0                                          \
                                             label.padding_left=0                                          \
                                             script="$PLUGIN_SHARED_DIR/time.sh"                 \
                                                                                                           \
              --add       item               date             right                                        \
              --set       date               update_freq=60                                                \
                                             background.color=0xffe8e8e9                                   \
                                             label.color=0xff000000                                        \
                                             label.font="SF Pro:Semibold:12"                               \
                                             icon.padding_right=0                                          \
                                             label.padding_left=0                                          \
                                             background.height=15                                          \
                                             background.corner_radius=4                                    \
                                             script="$PLUGIN_SHARED_DIR/date.sh"