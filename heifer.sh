#!/usr/bin/env bash

## @author  Jay Goldberg
## @email  jaymgoldberg@gmail.com
## @license  Apache 2.0
## @description  constrains an execution to memory and cpu limits using cgroups
## @usage  heifer.sh <cpushares_limit> <mem_limit> <command -args>
## @require  cgcreate
## @require  cgexec
## @require  sudo
#=======================================================================

cpulimit=${$1:-768} # 0-1024
memlimit=${$2:-4096} # in MB
process="${$3:-chrome$$}"

shift
shift

u=$(id -un)
g=$(id -gn)
sudo cgcreate -a "$u:$g" -t "$u:$g" -g cpu,memory:${process}

echo $cpulimit > /sys/fs/cgroup/cpu/${process}/cpu.shares
echo $(($memlimit*1024*1024)) > /sys/fs/cgroup/memory/${process}/memory.limit_in_bytes
cgexec -g cpu,memory:${process} $@

# delete the cgroup when script exits
sudo cgdelete memory,cpu:${process}
