#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @description records a region as a GIF, saves file and places on clipboard
## @license  Apache 2.0
## @usage  gifrecord.sh
## @requires  xrectsel from https://github.com/lolilolicon/xrectsel
## @requires  inotifywait from inotify-tools
## @requires  byzanz-record from byzanz
#=======================================================================

path=$HOME/Pictures/screenshots # where to save the screenshots
filename=screengif_$(date +"%Y-%m-%d-%H:%M:%S").gif
delay=2 # time to wait before starting recording
default_params="-c" # byzanz-record defaults
soundfile="/usr/share/sounds/KDE-Im-Irc-Event.ogg"

# Sound notification to let one know when recording is about to start (and ends)
beep() {
  paplay $soundfile & # or we can use canberra-gtk-play
}

countdown() {
  echo Delaying $delay seconds. After that, byzanz will start...
  for (( i=$delay; i>0; --i )) ; do
    echo $i
    sleep 1
done
}

# here is some cool xrectsel syntax, not sure to use exit $? or exit -1
xrectsel_area=$(xrectsel "--x=%x --y=%y --width=%w --height=%h") || exit $?

# Spawn recording, closing zenity stops the gif recording
# See http://bernaerts.dyndns.org/linux/331-linux-cancel-zenity-progress-dialog-right-way
(
  countdown
  byzanz-record $default_params $xrectsel_area $path/$filename
) | zenity --title "Recording" --progress --pulsate --cancel-label "Stop" &

# get zenity brother process which is parent of all running tasks
#PID_ZENITY=$(ps -C zenity h -o pid,command | grep "my specific title" | awk '{print $1}')
PID_ZENITY=$!
PID_PARENT=$(ps -p ${PID_ZENITY} -o ppid=)
PID_CHILDREN=$(pgrep -d ',' -P ${PID_PARENT})

#echo "$PID_ZENITY $PID_PARENT $PID_CHILDREN"

# loop to check that progress dialog has not been cancelled
while [ "$PID_ZENITY" != "" ]; do
  # get PID of running processes for the children
  PID_GRANDCHILDREN=$(pgrep -d ' ' -P "${PID_CHILDREN}")
  # check if zenity PID is still there (dialog box still open)
  PID_ZENITY=$(ps h -o pid -p ${PID_ZENITY})
  # sleep for 1 second
  sleep 1
done

# if some running tasks are still there, kill them
[ "${PID_GRANDCHILDREN}" != "" ] && kill -SIGTERM ${PID_GRANDCHILDREN}

# continue with script

# TODO: make sure zenity window opens NOT in the xrectsel area using --geometry=WIDTHxHEIGHT+X+Y
# args for zenity and some collision maths

inotifywait -e close_write "$path/$filename"

xclip -selection clipboard -t image/gif -i < "$path/$filename"

notify-send -t 1500 -u low "GIF saved as $path/$filename"
