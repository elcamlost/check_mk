#!/bin/bash

# Create SSMTP config
CFGFILE=/etc/ssmtp/ssmtp.conf

cat >$CFGFILE <<CONFIG
root=root
mailhub=${MAILHUB}
FromLineOverride=YES
CONFIG

chmod 640 $CFGFILE
chown root:mail $CFGFILE

if [ -n "${FORCEUPDATE+1}" ]; then
    omd update --conflict keepold cmk
fi

# Start check_mk
omd start && tail -f /var/log/nagios.log

