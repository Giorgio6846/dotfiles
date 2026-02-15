#!/usr/bin/env sh

export AUDIO_DEVICE="$(/opt/homebrew/bin/SwitchAudioSource -c output)"

sketchybar --set $NAME label="$AUDIO_DEVICE"