#!/usr/bin/env sh

# Get download and upload values (in kbps)
read DOWN UP <<EOF
$(/opt/homebrew/bin/ifstat -i en0 -b 0.1 1 | tail -n1 | awk '{print int($1), int($2)}')
EOF

format_speed() {
  if [ "$1" -gt 999 ]; then
    awk -v val="$1" 'BEGIN { printf "%03.0f Mbps", val / 1000 }'
  else
    awk -v val="$1" 'BEGIN { printf "%03.0f kbps", val }'
  fi
}

DOWN_FORMAT=$(format_speed "$DOWN")
UP_FORMAT=$(format_speed "$UP")

sketchybar -m \
  --set network_down label="$DOWN_FORMAT" icon.highlight=$([ "$DOWN" -gt 0 ] && echo on || echo off) \
  --set network_up   label="$UP_FORMAT"   icon.highlight=$([ "$UP" -gt 0 ] && echo on || echo off)
