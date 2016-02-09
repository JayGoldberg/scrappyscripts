#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @description  ancillary functions used by https://github.com/JayGoldberg/scrappyscripts/
## @license  Apache 2.0
## @usage  import into required script
#=======================================================================

screen_res () {
  # returns screen resolution of first returned monitor

  rawres=$(xrandr | grep \* | cut -d' ' -f4|head -n1)
  scrw=$((${rawres%x*}/2))
  scrh=${rawres#*x}

  # if panel size provided as arg
  if [ -n "$1" ]; then
    scrh=$((${scrh}-${1}))
  fi
  echo "${scrw}x${scrh}"
}

check_deps () {
  : # for args in $@, check for proper exit code from `which`
}
