#!/bin/sh

HEALTH_CHECK_SCRIPT='/etc/apcupsd/health_check.sh'
CRONTAB_FILE='/etc/crontabs/root'

# Add health check task to crontab
echo '>> Adding health check task to crontab...'

health_check_task=${SCHEDULE}'\t'${HEALTH_CHECK_SCRIPT}
grep=$(grep "${HEALTH_CHECK_SCRIPT}" ${CRONTAB_FILE})
if [ "${grep}" = "" ]; then
	echo "Adding..."
    echo -e "${health_check_task}" 2>&1 | tee -a ${CRONTAB_FILE}
else
    echo "Updating..."
    echo -e "${health_check_task}"
    sed -i '/health_check.sh/c'${health_check_task} ${CRONTAB_FILE}
fi

exec "$@"
