#!/usr/bin/env bash

# TODO: Refactor for use many layouts

function get_current_keyboard_layout {
    echo -n $(setxkbmap -query | grep layout | awk '{print $2}');
}

case "$(get_current_keyboard_layout)" in
    "ru")
        setxkbmap us
        ;;
    *)
        setxkbmap ru
        ;;
esac
