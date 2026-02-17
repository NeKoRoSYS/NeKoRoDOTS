#!/bin/bash

handle() {
    case $1 in
        workspace*)

        active_ws=$(hyprctl activeworkspace -j | jq '.id')

        hyprctl clients -j | jq -r '.[] | "\(.pid) \(.workspace.id)"' | while read -r pid ws; do
            if [ "$ws" != "$active_ws" ]; then
                renice -n 19 -p "$pid" > /dev/null 2>&1
            else
                renice -n 0 -p "$pid" > /dev/null 2>&1
            fi
        done
        ;;
  esac
}

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
