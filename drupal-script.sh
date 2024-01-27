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
chmod a+w /opt/drupal/web/sites/default/settings.php

# Creates and modifies php.ini
cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
sed -i '927s/;//' /usr/local/etc/php/php.ini
sed -i '928i\extension=ldap.so' /usr/local/etc/php/php.ini

#Install dependencies 
apt update
apt install -y libldap2-dev
docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
docker-php-ext-install ldap

composer require drush/drush
drush site-install standard \
  --account-name=${DRUPAL_ACCOUNT_NAME} \
  --account-pass=${DRUPAL_ACCOUNT_PASSWORD} \
  --account-mail=drupal_admin@mangoflame.com \
  --db-url=mysql://${DRUPAL_DATABASE_USER}:${DRUPAL_DATABASE_PASSWORD}@mariadb/${DRUPAL_DATABASE_NAME} \
  --db-su=root \
  --db-su-pw=${MYSQL_ROOT_PASSWORD} \
  --locale=en \
  --site-name="mangoflame" \
  --site-mail=mangoflame.com \
  -y

drush config-set "system.site" name "Mangoflame"
drush user-create ${DRUPAL_ACCOUNT_NAME} --password="${DRUPAL_ACCOUNT_PASSWORD}" --mail="drupal_admin@mangoflame.com"
drush user-add-role administrator --uid=2
drush cache-rebuild

drush en ldap_servers ldap_user ldap_query ldap_authentication ldap_authorization -y
service apache2 restart
