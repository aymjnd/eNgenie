# eNgenie
Nginx Genie

script for nginx virtualhost creation as easy as 1-2-3.

intended only for 
 - Ubuntu 14.04, nginx, php5-fpm
 - Ubuntu 16.04, nginx, php7-fpm
 
## Instructions for LEMP(Linux, Nginx, MySQL, PHP)
For 16.04
```bash
-snip-
```
 
## Instructions for Virtualhost
###For 14.04
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost14
$ sudo ./vhost [create|delete] [example.com]
```
###For 14.04 Global Shortcut
```bash
$ cd /usr/local/bin && sudo wget -O vhost14 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost14 && sudo chmod +x /usr/local/bin/vhost14
$ vhost14 [create|delete] [example.com]
```
-
###For 16.04
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost16
$ sudo ./vhost [create|delete] [domain]
```
###For 16.04 Global Shortcut
```bash
$ cd /usr/local/bin && sudo wget -O vhost16 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost14 && sudo chmod +x /usr/local/bin/vhost16
$ vhost16 [create|delete] [example.com]
```
