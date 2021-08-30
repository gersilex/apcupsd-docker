#!/bin/sh

/sbin/apcupsd
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apcups.d: $status"
  exit $status
fi

crond -b -l 2
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start crond: $status"
  exit $status
fi

while sleep 60; do
  ps aux | grep apcupsd | grep -q -v grep
  apcupsd_status=$?
  ps aux | grep crond | grep -q -v grep
  crond_status=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $apcupsd_status -ne 0 -o $crond_status -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
