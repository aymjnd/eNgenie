#!/bin/bash
TEXTDOMAIN=lemp

nginx=/var/www/html
### php-fpm restart command
restartfpm='systemctl restart php7.0-fpm'

### nginx restart command
restartnginx='systemctl reload nginx'

### set default nginx server block
nginxdefault='/etc/nginx/sites-available/default'

###check for root
if [ "$(whoami)" != 'root' ]; then
	echo $"You don't have the permission to run $0 as non-root user. Sudo maybe?"
		exit 1;
fi

###Update all things!
apt update && apt upgrade -y
###Install all necessary things!
apt install nginx curl mysql-server php-fpm php-mysql -y

###Get IP/domain server 
echo -n "Enter your Server IP or domain and press [ENTER]: "
read IP

### change /etc/php/7.0/fpm/conf.d/10-opcache.ini
opcache='/etc/php/7.0/fpm/conf.d/10-opcache.ini'
sh -c "echo 'opcache.enable=0' >> $opcache"

### restart php-fpm
$restartfpm

### edit 
if ! echo "server {
		listen 80 default_server;
		listen [::]:80 default_server;

		root /var/www/html;
		index index.php index.html index.htm index.nginx-debian.html;

		server_name $IP;

		location / {
			try_files $uri $uri/ =404;
		}

		location ~ \.php$ {
			include snippets/fastcgi-php.conf;
			fastcgi_pass unix:/run/php/php7.0-fpm.sock;
		}

		location ~ /\.ht {
			deny all;
		}
	}" >| $nginxdefault
then
	echo -e $"There is an ERROR create $nginxdefault file"
	exit;
else
	echo -e $"New $nginxdefault Created."
fi
### make sure nginx can start with new config
nginx -t

### restart nginx
$restartnginx

echo -e "\n\nValidate password sometimes messed up your password make sure to choose which suit you well...."
secure_mysql='mysql_secure_installation'
$secure_mysql

if ! echo $domain > $nginx/index.html
	then
		echo $"ERROR: Unable to write in $nginx/. Please check permissions."
		exit;
	else
		echo $"Added index.html into $nginx/"
	fi
if ! echo "<?php phpinfo(); ?>" > $nginx/info.php
	then
		echo $"ERROR: Unable to write in $nginx/. Please check permissions."
		exit;
else
	echo $"Added info.php into $nginx/"
fi


echo "You can check your webserver here http://$IP/info.php"