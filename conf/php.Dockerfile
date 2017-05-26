FROM php:7-fpm

## Git and unzip b-)
RUN apt-get update && apt-get install -y \
    git \
    unzip

## Install Composer - The magic tool
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

## Set timezone (This is for the system)
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
RUN "date"

## Install PDO and PDO_MySQL
RUN docker-php-ext-install pdo pdo_mysql

## Install xdebug - Next step, uncomment for awesomeness
#RUN pecl install xdebug
#RUN docker-php-ext-enable xdebug
#RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
#RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini##

## Aliases are cool, use them, but always remember the actual command
RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf2="php bin/console"' >> ~/.bashrc

## Install Symfony Installer
RUN mkdir -p /usr/local/bin
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

## Configure PHP for Symfony2
#All of this is required for intl, which is needed by the intl component of symfony, used by the validators
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
#For some reason symfony wants short open tag off
RUN echo "short_open_tag = Off" > /usr/local/etc/php/conf.d/symfony2.ini
RUN echo "date.timezone = Europe/Bucharest" >> /usr/local/etc/php/conf.d/symfony2.ini
