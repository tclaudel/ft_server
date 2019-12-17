# Image de base
FROM debian:buster

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

EXPOSE 80:80

WORKDIR	/var/www/html

#Creating database

#ADD ./srcs/setup_database.sh /usr/bin/setup_database.sh
#RUN chmod 755 /usr/bin/setup_database.sh
#CMD "setup_database.sh"

#Installing wordpress

ADD ./srcs/setup_wordpress.sh ./setup_wordpress.sh
RUN chmod 755 ./setup_wordpress.sh
CMD "setup_wordpress.sh"



ADD ./srcs/start.sh /usr/bin/start.sh
#ADD ./srcs/lunch_nginx.sh /usr/bin/lunch_nginx.sh
#ADD ./srcs/my_sql_install.sh /usr/bin/my_sql_install.sh
#ADD ./srcs/php_my_admin_install.sh /usr/bin/php_my_admin_install.sh

RUN chmod 755 /usr/bin/start.sh
#RUN chmod 755 /usr/bin/lunch_nginx.sh
#RUN chmod 755 ./usr/bin//my_sql_install.sh
#RUN chmod 755 /usr/bin//php_my_admin_install.sh

CMD "start.sh"