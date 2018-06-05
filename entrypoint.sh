#!/bin/bash

/usr/sbin/sshd
/etc/init.d/mysql start

echo
echo IP address is:
ifconfig | grep "inet addr" | grep -v "127.0.0.1"
echo 
echo SQL password is: $SQL_PASSWORD
echo
echo

COUNT=5
while [ $COUNT -gt 0 ] ;do
    echo -n "$COUNT "
    sleep 1
    let COUNT=$COUNT-1
done
echo -e "... Ready!"

touch /var/log/mysql/error.log
tail -f /var/log/mysql/error.log

/etc/init.d/mysql stop
sync
sleep 1