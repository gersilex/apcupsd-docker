#!/bin/bash -e

cd $(dirname $0)

source env.list

if  [[ "$1" == "stop" ]]; then
  docker stop apcupsd && docker rm apcupsd
  ./host-trigger-check.sh stop
fi

if echo "$1" | grep "rebuild" > /dev/null; then
  docker stop apcupsd && docker rm apcupsd
  docker stop apcupsd && docker rm apcupsd
  docker build --rm -t apcupsd-docker . 
fi

if echo "$1" | grep "start" > /dev/null; then
  ./host-trigger-check.sh start & 
  docker run --name=apcupsd -d -v /var/log/apcupsd:/var/log --env-file=./env.list --device=$APC_UPS_DEV -t apcupsd-docker &
fi


