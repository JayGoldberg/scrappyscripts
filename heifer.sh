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
processname="${$3:-heifer$$}"

shift
shift

u=$(id -un)
g=$(id -gn)

# create cgroup with -a (parameter owner) and -t (tasks file owner)
# if not exists, create
echo Opening sudo to create user-managed cgroup space
sudo cgcreate -a "$u:$g" -t "$u:$g" -g cpu,memory:${processname}

# can also use `cgset`
echo Setting CPU limit...
echo $cpulimit > /sys/fs/cgroup/cpu/${processname}/cpu.shares
echo Setting memory limit...
echo $(($memlimit*1024*1024)) > /sys/fs/cgroup/memory/${processname}/memory.limit_in_bytes

echo Executing the target binary "${processname}" using bash
cgexec -g cpu,memory:${processname} bash -c "$@"

# delete the cgroup when script exits
sudo cgdelete memory,cpu:${processname}
