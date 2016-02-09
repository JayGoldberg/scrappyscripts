#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @description  types out what's in your X Selection
## @license  Apache 2.0
## @usage  typepaste.sh
## @require  xdotool
## @require  xclip
#=======================================================================

# give you some time to switch to the window you want
sleep 1
xdotool type --delay 20 "$(xclip -o)"
exit 0
