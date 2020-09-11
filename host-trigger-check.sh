#!/bin/bash -e
#
# This script is part of apcupsd-docker by Leroy Foerster.

### custumize your action in a script with the same name of the action
action(){
  if [[ -f ${APC_SCR_DIR}/${2} ]]; then
    cd $APC_SCR_DIR
    ./${2}
  fi
}

### Do not change below. Except you know what you are doing ###
set -x
source env.list 

if [[ "$1" == "stop" ]]; then
  echo "quit" | timeout -k 0 1 nc ${DOCKER0_IP} ${DOCKER0_PORT}
  exit 0
fi

if [[ "$1" == "status" ]]; then
  if ps -ef | grep ${DOCKER0_PORT} | grep "nc" | grep -v "grep" > /dev/null; then
    echo "Service is ON"
  else
    echo "Service is OFF"   
  fi
  exit 0
fi


while true; do
  coproc nc -l ${DOCKER0_IP} ${DOCKER0_PORT}
  IFS="
"
  while read -r registry; do
     P1=$(echo $registry | awk -F' ' '{print $1}')
     P2=$(echo $registry | awk -F' ' '{print $2}')
     P3=$(echo $registry | awk -F' ' '{print $3}')
     P4=$(echo $registry | awk -F' ' '{print $4}')
     
     case $registry in
      ('quit') exit 0;;
      (*) action $P1 $P2 $P3 $P4;;
     esac
  done <&"${COPROC[0]}" 

done


