#!/bin/bash -e
#
# This script is part of apcupsd-docker by Leroy Foerster.

### custumize your action in a script with the same name of the action
action(){
  APC_EVENT=${1}
  if [[ -f ${APC_SCR_DIR}/${APC_EVENT} ]]; then
    RET_CODE=$(/bin/bash "${APC_SCR_DIR}/${APC_EVENT}" || echo $?)
    if [[ ! -z ${RET_CODE} && ! ${RET_CODE} -eq 0 ]]; then
      echo "[ERROR] host-trigger-check.sh - "$(date +{DATE_MASK})" the apcd hook script for event '${APC_EVENT}' return code '$RET_CODE'"
    fi 
  else
    echo "[WARN] host-trigger-check.sh - "$(date +${DATE_MASK})" can't find an hook script for apcd event '${APC_SCR_DIR}\${APC_EVENT}'"
  fi
}

set -x
### Do not change below. Except you know what you are doing ###
source env.list 
if [[ "$1" == "stop" ]]; then
  while ps -ef | grep host-trigger-check.sh | grep -v grep > /dev/null ; do
    echo "quit" | timeout -k 0 1 nc ${DOCKER0_IP} ${DOCKER0_PORT}
  done
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

if [[ "$1" != "start" ]]; then
  echo "[ERROR] valid options are: start, status and stop."
  exit 1
fi

while true; do
  coproc nc -l ${DOCKER0_IP} ${DOCKER0_PORT}
  IFS="\n"
  read -r APCD_EVENT <&"${COPROC[0]}" 
  kill "$COPROC_PID"
  case $APCD_EVENT in
      ('quit') exit 0;;
      (*) action $APCD_EVENT ;;
  esac 
done


