#!/bin/bash

#Rename no-debian-php
mv /etc/apt/preferences.d/no-debian-php /etc/apt/preferences.d/no-debian-php.backup

# Install Drupal Core
cd /opt/drupal
composer install && composer require 'drupal/ldap:^4.6'
apt update -y
apt install php8.2-ldap -y

# Create missing files/folders and gives write permissions
mkdir /opt/drupal/web/sites/default/files
chmod a+w /opt/drupal/web/sites/default/files
cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php

echo "$databases['default']['default'] = array(
  'database' => 'your_database_name',
  'username' => 'your_database_user',
  'password' => 'your_database_password',
  'host' => 'localhost',
  'port' => '3306',
  'driver' => 'mysql',
  'prefix' => '',
  'collation' => 'utf8mb4_general_ci',
);" > /opt/drupal/web/sites/default/settings.php

chmod a+w /opt/drupal/web/sites/default/settings.php

# Creates and modifies php.ini
cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
sed -i '927s/;//' /usr/local/etc/php/php.ini
sed -i '928i\extension=php_ldap.so' /usr/local/etc/php/php.ini

#Install dependencies 
apt update
apt install -y libldap2-dev
docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
docker-php-ext-install ldap
exit

