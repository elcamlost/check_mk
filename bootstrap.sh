#!/bin/bash

# Create SSMTP config
CFGFILE=/etc/ssmtp/ssmtp.conf

cat >$CFGFILE <<CONFIG
root=root
mailhub=${MAILHUB}
rewriteDomain=${MAILDOMAIN}
FromLineOverride=YES
CONFIG

chmod 640 $CFGFILE
chown root:mail $CFGFILE

# Start check_mk
CURRENT_VERSION=$(omd version cmk|perl -nE 'print [(split " ")]->[-1]')
mkdir -p /omd/versions/${CURRENT_VERSION}/skel
omd --force update --conflict install ${CMK_SITE} || \
omd start && tail -f /var/log/nagios.log
