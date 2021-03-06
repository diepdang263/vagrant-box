#!/usr/bin/env bash

set -e

cp /vagrant/config/system/sources.list /etc/apt/sources.list

apt-get update -y

# Install system library
apt-get -y install \
           software-properties-common \
           build-essential \
           tcl \
           make \
           gcc \
           g++ \
		       zip \
		       unzip \
           curl \
           aptitude \
           mcrypt

# Add PHP & Maria DB PPA
add-apt-repository ppa:ondrej/php
add-apt-repository ppa:ondrej/nginx
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mariadb.nethub.com.hk/repo/10.2/ubuntu xenial main'

apt-get update -y

# Install Nginx & PHP & GIT
apt-get -y install \
           nginx \
           php5.6-fpm \
           php5.6-common \
           php5.6-json \
           php5.6-gmp \
           php5.6-mysql \
           php5.6-dev \
           php5.6-mcrypt \
           php5.6-curl \
           php5.6-imagick \
           php5.6-xdebug \
           php5.6-memcached \
           php5.6-memcache \
           php5.6-gd \
           php5.6-intl \
           php5.6-mbstring \
		       php5.6-zip\
		       php5.6-xml \
		       php5.6-sqlite3 \
           php-fpm \
           php-common \
           php-json \
           php-geoip \
           php-gmp \
           php-mysql \
           php-dev \
           php-mcrypt \
           php-curl \
           php-imagick \
           php-xdebug \
           php-memcached \
           php-memcache \
           php-gd \
           php-intl \
           php-mbstring \
		       php-zip \
		       php-xml \
		       php-sqlite3 \
		       php-pear \
           git

# Install MariaDB
echo 'mariadb-server mysql-server/root_password password mysql' | debconf-set-selections
echo 'mariadb-server mysql-server/root_password_again password mysql' | debconf-set-selections
apt-get -y install mariadb-server

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Install Redis
apt-get -y install redis-server
apt-get -y install php-redis

# Remove un used folder
for ver in /etc/php/* ; do if [ ! -d $ver/fpm/conf.d ] ; then rm -rf $ver ; fi done

# Enable PHP Mods
for ver in /etc/php/* ; do if [ -d $ver ] ; then echo extension=redis.so > $ver/mods-available/redis.ini ; fi done
for ver in /etc/php/* ; do if [ -d $ver ] ; then echo extension=mcrypt.so > $ver/mods-available/mcrypt.ini ; fi done

for ver in /etc/php/* ; do if [ -d $ver/fpm/conf.d ] ; then ln -s $ver/mods-available/redis.ini $ver/fpm/conf.d/redis.ini ; fi done
for ver in /etc/php/* ; do if [ -d $ver/fpm/conf.d ] ; then ln -s $ver/mods-available/mcrypt.ini $ver/fpm/conf.d/mcrypt.ini ; fi done

# Copy config file
cp -R /vagrant/config/nginx /etc

for ver in /etc/php/* ; do cp /vagrant/config/php.ini $ver/cli/php.ini ; done
for ver in /etc/php/* ; do cp /vagrant/config/php.ini $ver/fpm/php.ini ; done

cp /vagrant/config/my.cnf /etc/mysql/my.cnf
mysql -uroot -pmysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mysql' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Restart service
service nginx restart
service php* restart
service mysql restart

# Add service start with system
rm /etc/systemd/system/mysql.service

systemctl enable nginx
systemctl enable mysql
systemctl enable redis-server
cd /etc/init.d && for script in php* ; do systemctl enable $script ; done

# Config alias
alias composer-php5='php5.6 /usr/local/bin/composer'
