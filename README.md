# eNgenie
Nginx Genie
now with Ubuntu 16.04 Apache2 

Bash script for nginx/apache2 virtualhost creation as easy as 1-2-3.

Intended only for:
 - Ubuntu 14.04, nginx, php5-fpm
 - Ubuntu 16.04, nginx, php7-fpm
 - Ubuntu 16.04, apache2, php7
 
## Instructions for LEMP(Linux, Nginx, MySQL, PHP)
For 16.04
```bash
-snip-
```
 
## Instructions for Virtualhost
For 14.04
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost14
$ sudo ./vhost14 [create|delete] [example.com]
```
For 14.04 Global Shortcut
```bash
$ cd /usr/local/bin && sudo wget -O vhost14 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost14 && sudo chmod +x /usr/local/bin/vhost14
$ sudo vhost14 [create|delete] [example.com]
```


For 16.04
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost16
$ sudo ./vhost16 [create|delete] [example.com]
```
For 16.04 Global Shortcut
```bash
$ cd /usr/local/bin && sudo wget -O vhost16 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost16 && sudo chmod +x /usr/local/bin/vhost16
$ sudo vhost16 [create|delete] [example.com]
```


For 16.04 Apache2 / Lamp Stack
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x a2vhost16
$ sudo a2dissite 000-default.conf
$ sudo ./a2vhost16 [create|delete] [example.com]
```
For 16.04 Apache2 / Lamp Stack Global Shortcut
```bash
$ cd /usr/local/bin && sudo wget -O vhost16 https://raw.githubusercontent.com/anazhd/eNgenie/master/a2vhost16 && sudo chmod +x /usr/local/bin/a2vhost16
$ sudo a2dissite 000-default.conf
$ sudo a2vhost16 [create|delete] [example.com]
```
