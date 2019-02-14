#!/bin/bash
TEXTDOMAIN=lemp

function install_packages()
{
	apt-get update  && apt-get install -y --allow-unauthenticated ${@} 
	echo 'Package installation completed'
}

## Usage
print_help(){
    cat <<EOH
Usage: $0 [-h] [-n]
    -h	| This help menu
    -n	| not installing MySQL
EOH
    exit 1
}

nginx=/var/www/html

### nginx restart command
restartnginx='systemctl reload nginx'

### set default nginx server block
nginxdefault='/etc/nginx/sites-available/default'

###check for root
if [ "$(whoami)" != 'root' ]; then
	echo $"You don't have the permission to run $0 as non-root user. Sudo maybe?"
		exit 1;
fi

###Install all necessary things!
function mysqlinstall(){
	apt install nginx curl mariadb-server redis-server -y
}

function nomysql(){
	apt install nginx curl redis-server -y
}

function ipaddr(){
###Get IP/domain server 
echo -n "Enter your Server IP or domain and press [ENTER]: "
read IP
}

### edit 
function editnginx(){
	if ! echo "server {
			listen 80 default_server;
			listen [::]:80 default_server;

			root /var/www/html;
			index index.php index.html index.htm index.nginx-debian.html;

			server_name $IP;

			location / {
				try_files \$uri \$uri/ =404;
			}

			location ~ \.php\$ {
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
}

function secureinstall(){
	echo -e "\n\nValidate password sometimes messed up your password make sure to choose which suit you well...."
	secure_mysql='mysql_secure_installation'
	$secure_mysql
}

function DBconfig(){

	# If /root/.my.cnf exists then it won't ask for root password
	if [ -f /root/.my.cnf ]; then
		echo "Please enter the NAME of the new database! (example: database1)"
		read dbname
		echo "Please enter the database CHARACTER SET! (example: latin1, utf8, ...)"
		read charset
		echo "Creating new database..."
		mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
		echo "Database successfully created!"
		echo "Showing existing databases..."
		mysql -e "show databases;"
		echo ""
		echo "Please enter the NAME of the new database user! (example: user1)"
		read username
		echo "Please enter the PASSWORD for the new database user!"
		read userpass
		echo "Creating new user..."
		mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
		echo "User successfully created!"
		echo ""
		echo "Granting ALL privileges on ${dbname} to ${username}!"
		mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
		mysql -e "FLUSH PRIVILEGES;"
		echo "You're good now :)"
		
	# If /root/.my.cnf doesn't exist then it'll ask for root password	
	else
		echo "Please enter root user MySQL password!"
		read rootpasswd
		echo "Please enter the NAME of the new database! (example: database1)"
		read dbname
		echo "Please enter the database CHARACTER SET! (example: latin1, utf8, ...)"
		read charset
		echo "Creating new database..."
		mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET ${charset} */;"
		echo "Database successfully created!"
		echo "Showing existing databases..."
		mysql -uroot -p${rootpasswd} -e "show databases;"
		echo ""
		echo "Please enter the NAME of the new database user! (example: user1)"
		read username
		echo "Please enter the PASSWORD for the new database user!"
		read userpass
		echo "Creating new user..."
		mysql -uroot -p${rootpasswd} -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
		echo "User successfully created!"
		echo ""
		echo "Granting ALL privileges on ${dbname} to ${username}!"
		mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
		mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
		echo "You're good now :)"
	fi

}

function redissetup(){
	echo "Enter your redis password: "
	read redispass
	sed -i 's|^supervised no|supervised systemd|g' /etc/redis/redis.conf
	sed -i "s|^# requirepass foobared|requirepass $redispass|g" /etc/redis/redis.conf
	systemctl restart redis
}

function trywrite(){
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
}

if [ "$1" = '-h' ]; then
	print_help
fi

if [ "$1" = '-n' ]; then
	install_packages
	ipaddr
	nomysql
	editnginx
	redissetup
	trywrite
else
	install_packages
	ipaddr
	mysqlinstall
	secureinstall
	editnginx
	DBconfig
	redissetup
	trywrite
fi
