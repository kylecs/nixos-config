#!/usr/bin/env bash
# Waybar "caffeine" toggle: prevent the machine from locking or suspending.
#
# hypridle owns the idle timers (5min lock, 15min suspend). "Caffeinated"
# simply means hypridle is stopped, so nothing fires; toggling off restarts it.
set -euo pipefail

caffeinated() {
    # caffeinated == hypridle is NOT running
    ! pgrep -x hypridle >/dev/null 2>&1
}

status() {
    if caffeinated; then
        printf '{"text":"󰅶","alt":"on","class":"active","tooltip":"Caffeine on — sleep & lock inhibited (click to disable)"}\n'
    else
        printf '{"text":"󰾪","alt":"off","class":"inactive","tooltip":"Caffeine off — auto lock & sleep enabled (click to stay awake)"}\n'
    fi
}

toggle() {
    if caffeinated; then
        hypridle >/dev/null 2>&1 & disown
    else
        pkill -x hypridle || true
    fi
    # let the process table settle, then nudge waybar to refresh this module
    sleep 0.3
    pkill -RTMIN+8 waybar || true
}

case "${1:-status}" in
    toggle) toggle ;;
    *) status ;;
esac
