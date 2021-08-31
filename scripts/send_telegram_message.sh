#!/bin/sh

hostname=`hostname`

curl -s \
  --data parse_mode=HTML \
  --data chat_id=${CHAT_ID} \
  --data text="<b>apcupsd</b>%0A      <i>from <b>#`hostname`</b></i>%0A%0A${1}" \
  "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  > /dev/null 2>&1

exit 0
