#!/usr/bin/env bash
# Replace 'apache2' or 'nginx' with your actual web server process name
SERVER_PROCESS="h2o"

# Get the parent PID
PARENT_PID=$(pgrep -o $SERVER_PROCESS)

# Get all child PIDs
CHILD_PIDS=$(pstree -p $PARENT_PID | grep -o '([0-9]\+)' | grep -o '[0-9]\+' | tr '\n' ',')

# Calculate total CPU usage
echo "Total CPU usage of $SERVER_PROCESS and all children:"
ps -p $PARENT_PID,$CHILD_PIDS -o %cpu --no-headers | awk '{sum+=$1} END {print sum"%"}'
