#!/bin/bash

if [ ! -d /usr/share/nginx/html/wp-content ];
then
    echo "Downloading WordPress..."
    cd /tmp && \
    wget -nv https://wordpress.org/latest.tar.gz && \
    tar xzf latest.tar.gz && \
    mv wordpress/* /usr/share/nginx/html/ && \
    chown -R www-data:www-data /usr/share/nginx/html/ && \
    rm -rf latest.tar.gz wordpress
fi

if [ ! -d /var/lib/mysql/wordpress ];
then
    echo "Initializing database..."
    PASS=$(pwgen -s 12 1)
    mysql_install_db > /dev/null 2>&1

    /usr/bin/mysqld_safe > /dev/null 2>&1 &
    RET=1
    while [[ RET -ne 0 ]]; do
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1
        RET=$?
    done
    mysql -uroot -e "CREATE DATABASE IF NOT EXISTS wordpress;"
    mysql -uroot -e "GRANT USAGE ON *.* TO 'wordpress'@'localhost' IDENTIFIED BY '$PASS';"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"
    mysqladmin -uroot shutdown
    echo "Username: wordpress"
    echo "Password: $PASS"
fi

exec /usr/bin/supervisord -n
