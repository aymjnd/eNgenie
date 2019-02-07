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
    -h  | This help menu
    -n  | not installing MySQL
EOH
    exit 1
}

nginx=/usr/share/nginx/html
### php-fpm restart command
restartfpm='service php5-fpm restart'

### nginx restart command
restartnginx='service nginx restart'

### set default nginx server block
nginxdefault='/etc/nginx/sites-available/default'

###check for root
if [ "$(whoami)" != 'root' ]; then
        echo $"You don't have the permission to run $0 as non-root user. Sudo maybe?"
                exit 1;
fi

###Install all necessary things!
function mysql(){
        apt install nginx curl mysql-server php-fpm php-mysql -y
}

function nomysql(){
        apt install nginx curl php5-fpm php5-mysql -y
}

function ipaddr(){
###Get IP/domain server
echo -n "Enter your Server IP or domain and press [ENTER]: "
read IP
}

### change /etc/php/7.0/fpm/conf.d/10-opcache.ini
function phpfpm7(){
        opcache='/etc/php5/fpm/conf.d/05-opcache.ini'
        sh -c "echo 'opcache.enable=0' >> $opcache"
        cgifix='/etc/php5/fpm/php.ini'
        sh -c "sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' $cgifix"

        ### restart php-fpm
        $restartfpm
}

### edit
function editnginx(){
        if ! echo "server {
                        listen 80 default_server;
                        listen [::]:80 default_server;

                        root /usr/share/nginx/html;
                        index index.php index.html index.htm index.nginx-debian.html;

                        server_name $IP;

                        location / {
                                try_files \$uri \$uri/ =404;
                        }

                        location ~ \.php\$ {
                                try_files \$uri =404;
                                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                                fastcgi_pass unix:/var/run/php5-fpm.sock;
                                fastcgi_index index.php;
                                fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                                include fastcgi_params;
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
        phpfpm7
        editnginx
        trywrite
else
        install_packages
        ipaddr
        mysql
        secureinstall
        phpfpm7
        editnginx
        trywrite
fi
