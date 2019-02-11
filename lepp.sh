#!/bin/bash
TEXTDOMAIN=lepp

function install_packages()
{
	echo 'Purging apache if installed'
	apt --purge remove *apache*
	apt-get update && apt-get install -y --allow-unauthenticated ${@} 
	echo 'Package installation completed'
}

## Usage
function print_help(){
    cat <<EOH
Usage: $0 [-h] [-n]
    -h	| This help menu
    -n	| install
EOH
    exit 1
}

nginx=/var/www/html

### nginx restart command
restartnginx='systemctl reload nginx'

### postgresql restart command
restartpostgres='systemctl start postgresql'

### set default nginx server block
nginxdefault='/etc/nginx/sites-available/default'

###check for root
if [ "$(whoami)" != 'root' ]; then
	echo $"You don't have the permission to run $0 as non-root user. Sudo maybe?"
		exit 1;
fi

###Install all necessary things!
function postgres(){
	apt install nginx nginx-common curl postgresql postgresql-contrib -y
}

function ipaddr(){
###Get IP/domain server 
	echo -n "Enter your Server IP or domain and press [ENTER]: "
	read IP
}

function psqlname(){
	echo -n "Enter your username that you want: "
	read psqluser
}

function psqlpwd(){
	echo -n "Enter your password for user '$psqluser': "
	read psqlpass
}

function nmDB(){
	echo -n "Enter your DB name that you want: "
	read namaDB
}
### edit 
function editnginx(){
	if ! echo "server {
			listen 80 default_server;
			listen [::]:80 default_server;

			root /var/www/html;
			index index.php index.js index.html index.htm index.nginx-debian.html;

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
    $restartpostgres
}

function tambahDB(){
	#sudo su postgres <<'EOF'
	#psql -c "CREATE DATABASE $namaDB;"
	#EOF
    echo -e "\nCREATE USER $psqluser WITH PASSWORD '$psqlpass';\nCREATE DATABASE $namaDB WITH OWNER $psqluser;\nGRANT ALL PRIVILEGES ON DATABASE $namaDB TO $psqluser;\n"
    sudo -u postgres psql -c "CREATE USER $psqluser WITH PASSWORD '$psqlpass';"
    sudo -u postgres psql -c "CREATE DATABASE $namaDB WITH OWNER $psqluser;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $namaDB TO $psqluser;"
    echo "Finished Database section"
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
	postgres
    psqlname
    psqlpwd
    nmDB
	editnginx
    tambahDB
	trywrite
else
	print_help
fi
