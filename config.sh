#!/bin/bash

# install dotnet core
sudo wget -q packages-microsoft-prod.deb https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i packages-microsoft-prod.deb
sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends apt-transport-https
sudo wget https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
sudo wget https://packages.microsoft.com/config/debian/8/prod.list | tee /etc/apt/sources.list.d/microsoft.list
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --yes dotnet-sdk-2.1.200

# download application
cd ~/
git clone https://github.com/gibbsa/sampleproject.git

# install nginx, update config file
sudo DEBIAN_FRONTEND=noninteractive apt-get --yes install -y nginx
sudo service nginx start
sudo touch /etc/nginx/sites-available/default
sudo wget https://raw.githubusercontent.com/gibbsa/sampleproject/master/default -O /etc/nginx/sites-available/default
#sudo cp /opt/music/nginx-config/default /etc/nginx/sites-available/
sudo nginx -s reload

# update and secure music config file
#sed -i "s/<replaceserver>/$1/g" /opt/music/config.json
#sed -i "s/<replaceuser>/$2/g" /opt/music/config.json
#sed -i "s/<replacepass>/$3/g" /opt/music/config.json
#sudo chown $2 /opt/music/config.json
#sudo chmod 0400 /opt/music/config.json

# config supervisor
#sudo apt-get install -y supervisor
#sudo touch /etc/supervisor/conf.d/music.conf
#sudo wget https://raw.githubusercontent.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/music-app/supervisor/music.conf -O /etc/supervisor/conf.d/music.conf
#sudo service supervisor stop
#sudo service supervisor start

# pre-create music store database
#/usr/bin/dotnet /opt/music/MusicStore.dll &