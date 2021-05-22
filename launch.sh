#!/bin/sh

/sbin/apcupsd -b
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apcups.d: $status"
  exit $status
fi