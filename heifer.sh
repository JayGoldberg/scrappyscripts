#!/bin/bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @license  Apache 2.0
## @description  constrains an execution to memory and cpu limits using cgroups
## @usage  heifer.sh <cpushares_limit> <mem_limit> <command -args>
## @require  cgcreate
## @require  cgexec
## @require  sudo
#=======================================================================

cpulimit=819 # 0-1024
memlimit=4096 # in MB

process="chrome"

u=$(id -un)
g=$(id -gn)
sudo cgcreate -a "$u:$g" -t "$u:$g" -g cpu,memory:${process}

echo $cpulimit > /sys/fs/cgroup/cpu/${process}/cpu.shares
echo $(($memlimit*1024*1024)) > /sys/fs/cgroup/memory/${process}/memory.limit_in_bytes
cgexec -g cpu,memory:chrome $@

# delete the cgroup when script exits
sudo cgdelete memory,cpu:${process}
