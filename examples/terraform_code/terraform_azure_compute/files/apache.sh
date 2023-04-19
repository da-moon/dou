#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<html><h1>Hello Terratest</h1><body><p>hey</p>this is a test</body></html>" | sudo tee /var/www/html/index.html

# Install sql server
sudo apt install -y npm
sudo apt install nodejs-legacy
sudo npm install -g sqlcmdjs
exec bash