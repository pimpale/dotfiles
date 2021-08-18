#!/bin/sh

#Change DVI-I-1 to what monitor you want from running command: xrandr
MONITOR="HDMI-0"
ID_STYLUS=`xinput | grep "Pen Pen" | cut -f 2 | cut -c 4-5`

xinput map-to-output $ID_STYLUS $MONITOR

exit 0
