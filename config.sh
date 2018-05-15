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
sudo nginx -s reload

# run app
/usr/bin/dotnet ./Sample App/bin/Debug/netcoreapp2.0/samplecoreapp.dll &