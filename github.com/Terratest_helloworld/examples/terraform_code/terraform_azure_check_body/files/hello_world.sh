#!/bin/bash
sudo apt update
sudo apt install nginx -y
sudo ufw allow 'Nginx HTTP'
sudo systemctl restart nginx

echo "Hello, World!" > index.html
#nohup busybox httpd -f -p 80