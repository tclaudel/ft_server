# Image de base
FROM debian:buster

LABEL tclaudel="contact@tclaudel.fr"

# Downloading packages
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y nginx
RUN apt-get install -y wget
RUN apt-get install -y default-mysql-server
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mbstring
RUN apt-get install -y git
RUN apt-get install -y php-mysql
RUN apt-get install -y zsh
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y default-mysql-client
RUN apt-get install -y libnss3-tools
RUN apt-get install -y npm

EXPOSE 80

COPY	srcs/default-off /etc/nginx/sites-available/default

#working in -> /var/www/html
WORKDIR	/var/www/html

RUN		mkdir /wordpress

#Installing oh-my-zsh
RUN		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Wordpress
COPY	srcs/wordpress ./wordpress/
COPY	srcs/wp-config.php wordpress/
COPY 	srcs/index.html ./
COPY 	srcs/logo_wordpress.jpg ./
COPY 	srcs/logo-phpmyadmin.jpg ./

#phpMyAdmin
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/4.9.2/phpMyAdmin-4.9.2-all-languages.tar.xz

RUN		tar xf phpMyAdmin-4.9.2-all-languages.tar.xz && \
		rm -f phpMyAdmin-4.9.2-all-languages.tar.xz && \
		mv phpMyAdmin-4.9.2-all-languages ./phpmyadmin

#Setup database
RUN		service mysql start && \
		echo "CREATE DATABASE wordpress;" | mysql -u root && \
		echo "ALTER USER root@localhost IDENTIFIED VIA mysql_native_password;"  | mysql -u root && \
		echo "CREATE user user@localhost identified by 'password';" | mysql -u root && \
		echo "SET PASSWORD = PASSWORD('password');" | mysql -u root && \
		echo "grant all privileges on wordpress.* to user@localhost;" | mysql -u root && \
		echo "flush privileges;" | mysql -u root

#mkcert
RUN		mkdir ~/mkcert && \
		cd ~/mkcert && \
  		wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
  		mv mkcert-v1.1.2-linux-amd64 mkcert && \
  		chmod +x mkcert && \
		./mkcert -install && \
		./mkcert localhost && \
		cp /root/mkcert/* /etc/nginx/

COPY	srcs/config.inc.php ./phpmyadmin/

RUN		chmod 660 /var/www/html/phpmyadmin/config.inc.php && chown -R www-data:www-data /var/www/html/phpmyadmin

RUN		chown www-data:www-data * -R && usermod -a -G www-data www-data

CMD 	service mysql restart 2> /dev/null && echo "Launching nginx" && service php7.3-fpm start &&  nginx -g 'daemon off;'