FROM ubuntu:bionic

RUN apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:ondrej/php && \
  apt-get update

RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata && \
  ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -y libterm-readline-gnu-perl && \
  apt-get install -y php7.0 php7.0-mbstring php7.0-mysql php7.0-xml
RUN apt-get install -y apache2 

RUN a2dismod php5 || true
RUN a2enmod php7.0 && \
  phpenmod pdo_mysql

RUN rm -f /var/www/html/index.html
COPY ./ /var/www/html/
RUN chown -R www-data /var/www/html

CMD /bin/bash -c "source /etc/apache2/envvars && apache2 -D FOREGROUND"

