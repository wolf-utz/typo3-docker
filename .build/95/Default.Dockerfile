#==========================================================
# TYPO3 87 (PHP 7.2, Apache)
#==========================================================
# Image: php:7.2-apache
#==========================================================
FROM php:7.2-apache
# Build custom image.
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
        curl \
        libfreetype6-dev \
        libxml2-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
        graphicsmagick \
	# Install PHP extensions.
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        zip \
        opcache \
        soap \
        pdo_mysql \
        intl \
    && pecl install apcu \
    && pecl install xdebug \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable xdebug \
    # Add composer.
	&& curl -sS https:/getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	# Configure apache.
	&& a2enmod rewrite
# Add custom php.ini.
ADD ./.build/95/php.ini /usr/local/etc/php/conf.d/z99-additional-php.ini
# Add vhost.
ADD ./.build/95/vhost.conf /etc/apache2/sites-enabled/000-default.conf
# Install TYPO3 95.
RUN cd /var/www/html \
    && curl -L get.typo3.org/9.5 --output typo3_src-9.5.tar.gz \
    && tar -xzf typo3_src-9.5.tar.gz \
    && ln -s typo3_src*/ typo3_src \
    && ln -s typo3_src/typo3 typo3 \
    && ln -s typo3_src/index.php index.php \
    && cp typo3/sysext/install/Resources/Private/FolderStructureTemplateFiles/root-htaccess .htaccess \
    && mkdir typo3temp \
    && mkdir typo3conf \
    && mkdir fileadmin \
    && mkdir uploads \
    && touch FIRST_INSTALL \
    && chown -R www-data:www-data .
# Clean up.
RUN apt-get clean \
    && apt-get -y purge \
        curl \
        libfreetype6-dev \
        libxml2-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* /usr/src/*
# Configure volumes.
VOLUME /var/www/html/fileadmin
VOLUME /var/www/html/typo3conf
VOLUME /var/www/html/uploads