#!/bin/bash
set -x

wineboot --init
wineboot -u

Xvfb :0 -auth ~/.Xauthority -screen 0 1024x768x24 >>~/xvfb.log 2>&1 & 
XVFB_PID=$!
export DISPLAY=:0
sleep 2
 
winetricks -q vcrun6 || exit 1
kill $XVFB_PID
