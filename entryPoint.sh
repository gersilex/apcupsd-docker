#!/bin/sh
rm -f /tmp/f
mkfifo /tmp/f
tail -f /tmp/f | nc ${DOCKER0_IP} ${DOCKER0_PORT} &
/sbin/apcupsd -b
