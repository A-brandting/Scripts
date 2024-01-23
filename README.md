Webserver install
1: Create a file on desktop
•	Touch script.sh

2: Give execute permissions to the script.
•	Chmod +x script.sh

3: Insert code from this link into the script
•	raw.githubusercontent.com/A-brandting/Scripts/main/create-docker.sh

4: Run the script
•	sudo ./script.sh

5: Enter Drupal container:
•	sudo docker exec -it lamp-drupal-1 bash

6: Rename file to be able to download php extensions.
•	 cd /etc/apt/preferences.d
•	 mv no-debian-php no-debian-php.backup

7: Install drupal core.
•	cd /opt/drupal
•	composer install / if possible (composer require drupal/ldap_auth)

8: Install PHP-ldap.
•	apt-get update
•	apt-get install php8.2-ldap -y

9: Create missing folders and files and change permissions.
•	mkdir /opt/drupal/web/sites/default/files
•	chmod a+w /opt/drupal/web/sites/default/files
•	cp /opt/drupal/web/sites/default/default.settings.php /opt/drupal/web/sites/default/settings.php
•	chmod a+w /opt/drupal/web/sites/default/settings.php

10: Create Database in phpMyAdmin (localhost:8080).
•	Database name: drupal_database

11: Create Database user in phpMyAdmin (localhost:8080).
•	Username: drupal_user
•	Hostname: %
•	Password: ************
•	Authentication plugin: Native MySQL authentication.
•	Global privileges [X] Check all

12: Enter database configuration settings: (localhost:8081).
•	Database type: MySQL,MariaDB,percona Server, or equivalent.
•	Database name: drupal_database
•	Database username: drupal_user
•	Database password: ***********
•	Host: localhost
•	Port number: 3306
•	Transaction isolation level: READ COMMITTED

13: *** REMOVE WRITE PERMISSIONS: sites/default/files and sites/default/settings.php ***

14: Configure site.
•	Site name: Mangoflame
•	Site email address: Random@gmail.com

SITE MAINTENANCE ACCOUNT.
•	Username: drupal_admin
•	Password: **************
•	Email address: Random@gmail.com

15: Install Active Directory / LDAP Integration extension for drupal
•	 sudo docker exec -it lamp-drupal-1 bash
•	composer require drupal/ldap_auth

16: Go back to localhost:8081/admin/modules

17: Install Plugin: Active Directory / LDAP integration

18: Create file PHP.ini and modify its content.
•	 Sudo docker exec -it lamp-drupal-1 bash
•	Cd /usr/local/etc/php
•	Cp php.ini-production php.ini
•	Go into file and edit: (nano php.ini)(Ctrl + w and search for {ldap})
    o	extension=ldap (remove semicolon in front of the line)
    o	extension=php_ldap.so (if line doesn’t exist, add it)

19: Install php dependencies in drupal docker.
•	apt-get update
•	apt-get install -y libldap2-dev
•	docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
•	docker-php-ext-install ldap
•	 service apache2 restart
•	 exit

20: Start drupal docker.
•	sudo docker start lamp-drupal-1

21: Connect drupal to openldap.
•	ldap://IP_TO_LDAPSERVER:1389

22: Service Account / Bind details.
•	Bind Account DN: cn=ldap_admin,dc=mangoflame,dc=com
•	Bind Account Password: *************

23: Select search base & filter.
•	Select base: dc=mangoflame,dc=com
•	LDAP Username Attribute / Search Filter: CN
•	Enable Login with LDAP

24: DONE
