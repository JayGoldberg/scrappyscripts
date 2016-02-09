#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @description  appends little text lines using a popup window
##   just tie it to a keybinding in your window manager
## @license  Apache 2.0
## @usage  guinote.sh <filename>
## @requires  zenity
#=======================================================================

progfile=~/${1}
timestamp=$(date +%Y-%m-%d_%H:%M:%S)
title="Enter note"

query=$(zenity --entry --title="$title" --text="Note text for $progfile:")
output=0

echo "$timestamp $query" >> "$progfile"

exit 0
