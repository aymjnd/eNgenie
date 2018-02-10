# eNgenie
eNgenie was initially scripted for LEMP stack running on default Ubuntu 14/16 environment. Now with Ubuntu 16.04 Apache2 support. eNgenie is a collection of script to help you with server block or virtualhost creation with ease. You can find many other script, or you might already know there are plenty of this out there but our script is specifically for the default LAMP/LEMP stack environment, out of the box. For custom setup (e.g custom package repo/ppa), you might need to change the code before using.

Intended only for this setup:
 - Ubuntu 14.04 nginx, php5-fpm
 - Ubuntu 16.04, nginx, php7-fpm
 - Ubuntu 16.04, apache2, php7
 ----------
## Instructions for LEMP(Linux, Nginx, MySQL, PHP)
For 16.04
```bash
$./lemp.bash -h
Usage: ./lemp.bash [-h] [-n]
    -h  | This help menu
    -n  | not installing MySQL
```

By default this script will update and upgrade your box and install nginx curl mysql-server php-fpm php-mysql

to skip mysql installation, use `-n` switch
```bash
$./lemp.bash -n
```
 ----------
## Instructions for Virtualhost

**For 14.04 + LEMP**
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost14
$ sudo ./vhost14 [create|delete] [example.com]
```
**For 14.04 +LEMP Global Shortcut**
```bash
$ cd /usr/local/bin && sudo wget -O vhost14 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost14 && sudo chmod +x /usr/local/bin/vhost14
$ sudo vhost14 [create|delete] [example.com]
```


----------


**For 16.04 + LEMP**
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x vhost16
$ sudo ./vhost16 [create|delete] [example.com]
```
**For 16.04 + LEMP Global Shortcut**
```bash
$ cd /usr/local/bin && sudo wget -O vhost16 https://raw.githubusercontent.com/anazhd/eNgenie/master/vhost16 && sudo chmod +x /usr/local/bin/vhost16
$ sudo vhost16 [create|delete] [example.com]
```


----------


**For 16.04 + LAMP**
```bash
$ git clone https://github.com/anazhd/eNgenie.git
$ cd eNgenie
$ chmod +x a2vhost16
$ sudo a2dissite 000-default.conf
$ sudo ./a2vhost16 [create|delete] [example.com]
```
**For 16.04 + LAMP Global Shortcut**
```bash
$ cd /usr/local/bin && sudo wget -O a2vhost16 https://raw.githubusercontent.com/anazhd/eNgenie/master/a2vhost16 && sudo chmod +x /usr/local/bin/a2vhost16
$ sudo a2dissite 000-default.conf
$ sudo a2vhost16 [create|delete] [example.com]
```
