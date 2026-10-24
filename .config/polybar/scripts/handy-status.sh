#!/usr/bin/env bash

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/handy/recording-state"

if [[ -f "$STATE_FILE" ]] && [[ "$(cat "$STATE_FILE")" == "recording" ]]; then
    printf '%%{F#50FA7B}󰍬 REC%%{F-}'
else
    printf '%%{F#6272A4}󰍬 OFF%%{F-}'
fi
