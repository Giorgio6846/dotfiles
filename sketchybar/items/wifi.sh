source "$PLUGIN_SHARED_DIR/wifi.sh"

sketchybar --add item           wifi.control right                      \
                                                                        \
           --set wifi.control   icon=$WIFI_ICN                                \
                                label.drawing=off                       \
                                click_script="$POPUP_CLICK_SCRIPT"      \
                                popup.background.color=0x70000000       \
                                popup.blur_radius=50                    \
                                popup.background.corner_radius=5        \
                                                                        \
           --add item           wifi.ssid popup.wifi.control            \
           --set wifi.ssid      icon=$NETWORK_ICN                                \
                                label="${SSID}"                         \
                                                     