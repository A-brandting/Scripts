#!/bin/bash

# Installing Docker
apt update
apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Installing Docker-Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

if [ "$(systemctl is-active docker)" != "active" ]; then
    echo "Something went wrong with the installation"
    exit 1
fi

# Creating directory structure

    mkdir /home/lamp
    mkdir /home/lamp/{apache_docker,php_docker,www,drupal}

# Downloading env-file

    curl https://raw.githubusercontent.com/A-brandting/Scripts/main/secrets.env > /home/lamp/.secrets.env
    chmod 600 /home/lamp/.secrets.env

# Downloading scripts from github
    
    # Creates lamp/Docker-compose.yaml
    curl https://raw.githubusercontent.com/A-brandting/Scripts/main/docker-compose.yaml > /home/lamp/docker-compose.yaml

    # Creates PHP_docker/Dockerfile
    curl https://raw.githubusercontent.com/A-brandting/Scripts/main/php-dockerfile > /home/lamp/php_docker/Dockerfile

    # php info on localhost
    echo "<?php phpinfo(); ?>" > /home/lamp/www/index.php

    # Creates Apache-vhost.conf
    curl https://raw.githubusercontent.com/A-brandting/Scripts/main/apache-vhost.conf > /home/lamp/apache_docker/apache-vhost.conf

    # Creates Apache_docker/Dockerfile
    curl https://raw.githubusercontent.com/A-brandting/Scripts/main/apache-dockerfile > /home/lamp/apache_docker/Dockerfile
    cd /home/lamp
    
   docker-compose --env-file ./.secrets.env up -d

# Running drupal-script
   touch /home/lamp/drupal/drupal-script.sh
   chmod +x /home/lamp/drupal/drupal-script.sh
   curl https://raw.githubusercontent.com/A-brandting/Scripts/main/drupal-script.sh > /home/lamp/drupal/drupal-script.sh
   docker exec lamp-drupal-1 /opt/drupal/web/drupal-script.sh

