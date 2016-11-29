#!/usr/bin/env bash

function get_date {
    local datetime=$(date "+%Y-%m-%d %H:%M");
    echo -n ${datetime};
}

while true; do
    echo "%{Sf}%{r}$(get_date)%{r}%{S}"
    sleep 1
done
