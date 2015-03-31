#!/bin/bash

SCREENS="-screen 800x600"

if [ $1 ]; then

    SCREENS="$SCREENS -screen 800x600"

fi

Xephyr -ac -br -noreset +xinerama ${SCREENS} :1 &
ZEPHYR_PID=$!
sleep 1
DISPLAY=:1 awesome -c $HOME/.config/awesome/rc.test.lua
kill $ZEPHYR_PID
