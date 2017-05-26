# eNgenie
Nginx Genie

script for nginx virtualhost creation as easy as 1-2-3.

intended only for 
 - Ubuntu 14.04, nginx, php5-fpm
 - Ubuntu 16.04, nginx, php7-fpm
 
##Instructions for LEMP(Linux, Nginx, MySQL, PHP)
For 16.04
```bash
git clone https://github.com/anazhd/eNgenie.git
cd eNgenie
chmod +x lemp.bash
sudo ./lemp.bash
```
 
 ##Instructions for Virtualhost
For 14.04
```bash
git clone https://github.com/anazhd/eNgenie.git
cd eNgenie
chmod +x vhost
sudo ./vhost [create|delete]
```
For 16.04
```bash
git clone https://github.com/anazhd/eNgenie.git
cd eNgenie
chmod +x vhost16.04
sudo ./vhost [create|delete]
```