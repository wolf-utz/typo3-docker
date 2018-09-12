#==========================================================
# PHP 7.x (Apache)
#==========================================================
# Image: php:7.x-apache
#==========================================================
ARG MINOR_VERSION
FROM php:7.${MINOR_VERSION}-apache
# Build custom image.
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	# Install PHP extensions.
	&& docker-php-ext-install -j$(nproc) \
        mysqli \
        opcache \
        pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    # Add composer.
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	# Configure apache.
	&& a2enmod rewrite
# Add custom php.ini.
ADD ./.build/PHP7/php.ini /usr/local/etc/php/conf.d/z99-additional-php.ini
# Add vhost.
ADD ./.build/PHP7/vhost.conf /etc/apache2/sites-enabled/000-default.conf
# Clean up.
RUN apt-get clean \
    && apt-get -y purge \
    && rm -rf /var/lib/apt/lists/* /usr/src/*
# Configure volumes.
VOLUME /var/www/html/app