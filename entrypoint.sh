#!/bin/sh

/usr/sbin/sshd
/etc/init.d/mysql start

ifconfig

COUNT=3
while [ $COUNT -gt 0 ] ;do
    echo -n "$COUNT "
    sleep 1
    let COUNT=$COUNT-1
done
echo -e "... Ready!"

#mysql -u root -e " \
#  SET PASSWORD = PASSWORD('mysql'); \
#  UPDATE mysql.user SET password = PASSWORD('mysql') WHERE user = 'root'; \
#  DELETE FROM mysql.user WHERE user = ''; \
#  GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'mysql' WITH GRANT OPTION; \
#  GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mysql' WITH GRANT OPTION; \
#  FLUSH PRIVILEGES; \
#"

tail -f /var/log/mysql/error.log
