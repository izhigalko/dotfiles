#!/usr/bin/env bash

DEFAULT_KEYBOARD_LAYOUTS="us ru"
DEFAULT_KEYBOARD_LAYOUT="us"

function get_current_keyboard_layout {
    echo -n $(setxkbmap -query | grep layout | awk '{print $2}' | awk -F ',' '{print $1}');
}

function get_next_layout_or_first {
    local current_layout=$1;
    local layouts=( ${@:2} );
    local default_layout=$([[ ! -z ${layouts[0]} ]] && echo ${layouts[0]} || echo ${DEFAULT_KEYBOARD_LAYOUT});
    local next_layout;

    for i in "${!layouts[@]}" ; do
        if [[ ${layouts[i]} = ${current_layout}  ]] ; then
            next_layout=${layouts[$i+1]};
        fi;
    done;

    [[ ! -z ${next_layout} ]] && echo ${next_layout} || echo ${default_layout};
}

layouts=( $([[ ! -z ${KEYBOARD_LAYOUTS} ]] && echo ${KEYBOARD_LAYOUTS} || echo ${DEFAULT_KEYBOARD_LAYOUTS}) );
current_layout=$(get_current_keyboard_layout);
next_layout=$(get_next_layout_or_first ${current_layout} ${layouts[@]});

new_layouts=( "${next_layout}" );
new_layouts+=( ${layouts[@]/${next_layout}} );
new_layouts=$(IFS=, ; echo "${new_layouts[*]}");

setxkbmap ${new_layouts};