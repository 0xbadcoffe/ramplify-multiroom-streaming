#!/bin/bash -e

yes | bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo systemctl enable nodered.service

sudo node-red-stop

sudo rm /home/pi/.node-red/settings.js
sudo cp /home/pi/Ramplify/templates/settings.js.template /home/pi/.node-red/
sudo mv /home/pi/.node-red/settings.js.template /home/pi/.node-red/settings.js

sudo apt install iptables-persistent -y
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i wlan0 -p tcp --dport 80 -j REDIRECT --to-port 1880
sudo netfilter-persistent save
sudo netfilter-persistent reload
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 1880
sudo netfilter-persistent save
sudo netfilter-persistent reload
