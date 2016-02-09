#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @description  captures a region as a PNG, saves file and places on clipboard
## @license  Apache 2.0
## @usage  screenshot_xrectsel.bash
## @requires  xrectsel from https://github.com/lolilolicon/xrectsel
## @requires  import from ImageMagick
#=======================================================================

path=$HOME/Pictures/screenshots # where to save the screenshots
filename=screenshot_$(date +"%Y-%m-%d-%H:%M:%S").png

# here is some cool xrectsel syntax, not sure to use exit $? or exit -1
#xrectsel_area=$(xrectsel "%wx%h+%x+%y" || exit $?)

import -window root -crop $(xrectsel "%wx%h+%x+%y") -quality 75 $path/$filename

xclip -selection clipboard -t image/png -i < "$path/$filename"

notify-send -t 1500 -u low "Screenshot saved as $path/$filename and put on clipboard"
