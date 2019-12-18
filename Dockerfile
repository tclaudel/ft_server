# Image de base
FROM debian:buster

LABEL tclaudel="contact@tclaudel.fr"

# Downloading packages
RUN apt-get update
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

EXPOSE 80

COPY	srcs/default.conf /etc/nginx/sites-enabled/

RUN		rm -f /etc/nginx/sites-enabled/default

#working in -> /var/www/html
WORKDIR	/var/www/html

#Installing oh-my-zsh
RUN		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Wordpress
RUN		wget https://wordpress.org/latest.tar.gz

RUN		tar xvf latest.tar.gz && \
		rm -f latest.tar.gz

COPY	srcs/wp-config.php wordpress/
COPY 	srcs/index.html ./
COPY 	srcs/logo_wordpress.jpg ./
COPY 	srcs/logo-phpmyadmin.jpg ./

#Setup database
RUN		service mysql start && \
		mysql -e "CREATE DATABASE wordpress" && \
		mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';" && \
		mysql -e "GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'root'@'localhost' IDENTIFIED BY 'password';" && \ 
		mysql -e "FLUSH PRIVILEGES;"

CMD 	service mysql restart && echo "Launching nginx" && service php7.3-fpm start &&  nginx -g 'daemon off;'