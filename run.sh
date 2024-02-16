#! /bin/sh

set -e

if [ "${MODE}" = "mysql" ]; then
  if [ "${SCHEDULE}" = "**None**" ]; then
    sh backup_mysql.sh
  else
    date
    chmod +x /backup_mysql.sh
    echo "${SCHEDULE} /bin/sh /backup_mysql.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root
    crond -f -l 8
  fi
elif [ "${MODE}" = "postgres" ]; then
  if [ "${SCHEDULE}" = "**None**" ]; then
    sh backup_postgres.sh
  else
    date
    chmod +x /backup_postgres.sh
    echo "${SCHEDULE} /bin/sh /backup_postgres.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root
    crond -f -l 8
  fi
else
  if [ "${SCHEDULE}" = "**None**" ]; then
    sh backup_file.sh
  else
    date
    chmod +x /backup_file.sh
    echo "${SCHEDULE} /bin/sh /backup_file.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root
    crond -f -l 8
  fi
fi