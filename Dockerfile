################################################################################
# base system
################################################################################
FROM silasmariusz/iobenchtune-qnap

LABEL maintainer="silas@qnapclub.pl"
MAINTAINER Silas Mariusz <silas@qnapclub.pl>

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/ubuntu 																		\
    SHELL=/bin/bash


# Generate MySQL password
RUN export SQL_PASSWORD=$(tr -dc 'A-HJ-NP-Za-km-z2-9' < /dev/urandom | dd bs=8 count=1 status=none) \
	&& echo -en "\nexport SQL_PASSWORD=$SQL_PASSWORD\n" >> /root/.profile 							\
	&& echo -n "$SQL_PASSWORD" > /root/mysql.pwd


ENV MYSQL_USER=mysql 																		\
    MYSQL_DATA_DIR=/var/lib/mysql 																\
    MYSQL_RUN_DIR=/run/mysqld 																	\
    MYSQL_LOG_DIR=/var/log/mysql


ENV SQL_PASSWORD="$(cat /root/mysql.pwd)"


#RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list


# Install Basics: Utilities and some dev tools
RUN apt-get update 																		\
	&& apt-get install -y --force-yes --no-install-recommends 												\
		software-properties-common 															\
		debconf-utils 																	\
		curl 																		\
		ca-certificates 																\
		openssh-server 																	\
		sudo 																		\
		net-tools 																	\
		build-essential 																\
		bash 																		\
		unzip 																		\
		apt-transport-https 																\
	&& apt-get autoclean 																	\
	&& apt-get autoremove 																	\
	&& rm -rf /var/lib/apt/lists/*


# Set default login and password for SSH root user...
RUN echo 'root:root' | chpasswd


# Configure SSH ...
RUN mkdir /var/run/sshd \
    && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config 				\
    && sed -ri 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config 		\
    && sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 	\
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 								\
	&& echo Configuring SSH finished. Launching SSH daemon... 


# Install MySQL
RUN SQL_PASSWORD=$(cat /root/mysql.pwd) 																		\
	&& debconf-set-selections <<< 'mysql-server mysql-server/root_password password $SQL_PASSWORD' 				\
	&& debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $SQL_PASSWORD' 		\
	&& debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password $SQL_PASSWORD' 			\
	&& debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password $SQL_PASSWORD' 	\
	&& apt-get update 																							\
	&& apt-get install -y --force-yes --no-install-recommends 													\
#		mysql-server-5.6 																						\
		mysql-server-5.7 																						\
		mysql-client 																							\
#	&& mysql_secure_installation 																				\
#	&& mysql_install_db 																						\
	&& mysql -u root -password -e "use mysql; UPDATE user SET authentication_string=PASSWORD('${SQL_PASSWORD}') WHERE User='root'; flush privileges;" \
	&& apt-get autoclean 																		\
	&& apt-get autoremove 																		\
	&& rm -rf ${MYSQL_DATA_DIR} 																	\
	&& rm -rf /var/lib/apt/lists/*																\
	echo Done installing MySQL ...


# Set Timezone (Server/MySQL)
#RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime 												\
#	&& mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=${SQL_PASSWORD} mysql


# Add 1GB swap for memory overflow
RUN fallocate -l 128M /swapfile 																\
	&& chmod 600 /swapfile 																		\
	&& mkswap /swapfile 																		\
	&& swapon /swapfile 																		\
	&& echo "/swapfile   none	swap	sw	0   0" | sudo tee -a /etc/fstab 					\
	&& printf "vm.swappiness=10\nvm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf 		\
	&& sudo sysctl -p


# Allow caching of NFS file share
RUN apt-get update 																				\
	&& apt-get install -y --force-yes --no-install-recommends 									\
		cachefilesd 																			\
	&& echo "RUN=yes" | sudo tee /etc/default/cachefilesd


# Copy entrypoint.sh
#COPY entrypoint.sh /sbin/entrypoint.sh
ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh


EXPOSE 22 3306
VOLUME ["${MYSQL_DATA_DIR}", "${MYSQL_RUN_DIR}"]
WORKDIR /root
ENTRYPOINT ["/sbin/entrypoint.sh"]
