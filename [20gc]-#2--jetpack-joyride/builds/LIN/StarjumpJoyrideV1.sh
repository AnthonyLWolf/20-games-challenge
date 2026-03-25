#!/bin/sh
printf '\033c\033]0;%s\a' [20GC] #2- Jetpack Joyride
base_path="$(dirname "$(realpath "$0")")"
"$base_path/StarjumpJoyrideV1.x86_64" "$@"
