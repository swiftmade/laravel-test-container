FROM php:8.2

ARG BUILD_DATE
ARG VCS_REF
ENV COMPOSER_ALLOW_SUPERUSER 1

LABEL Maintainer="Swiftmade <hello@swiftmade.co>" \
    Description="A simple PHP 8.2 image which contain just the minimum required to run Dusk on bitbucket pipelines." \
    org.label-schema.name="swiftmade/laravel-test-container:8.2" \
    org.label-schema.description="Laravel test container w/ all necessary extensions to run PHPUnit and Laravel Dusk tests." \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-url="https://github.com/swiftmade/laravel-test-container" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.schema-version="1.0.0"

ENV COMPOSER_ALLOW_SUPERUSER 1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update && apt-get install -y -q --no-install-recommends git \
    libsodium-dev unzip zlib1g-dev libxpm4 libxrender1 libgtk2.0-0 libnss3 \
    libgconf-2-4 chromium xvfb gtk2-engines-pixbuf  \
    imagemagick x11-apps libicu-dev \
    libzip-dev libpq-dev libxml2-dev libjpeg-dev libpng-dev

# Configure/install PHP extensions
RUN docker-php-source extract \
    && pecl install redis libsodium xdebug \
    && docker-php-ext-enable xdebug redis \
    && docker-php-source delete \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" pdo pdo_mysql pdo_pgsql pgsql intl zip soap gd exif bcmath pcntl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN Xvfb -ac :0 -screen 0 1280x1024x16 &
RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;