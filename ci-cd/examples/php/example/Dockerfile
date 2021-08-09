#FROM composer:latest AS composer
FROM mlocati/php-extension-installer:latest as php-extension-installer
########################################################
#################### BASE ###############################
########################################################
FROM php:7.4.16-fpm-alpine3.13 AS base
ARG user=testuser
ARG pass='wqeqwe12323#@32131'
RUN apk add --no-cache --update openssh openssh-server-pam make autoconf git nano wget bash sphinx supervisor rsync pngquant jpegoptim sudo binutils gcc g++ zlib-dev mc &&\
    rm -rf /var/cache/apk/* &&\
    #pear config-set php_ini $PHP_INI_DIR/php.ini &&\
    #pecl config-set php_ini $PHP_INI_DIR/php.ini &&\
    adduser $user -s /bin/bash -D --home /home/$user  && echo -e "$pass\n$pass" | passwd $user && adduser $user wheel &&\
    addgroup -g 99 -S apache && adduser apache -u 99 -D -S -G apache &&\
    adduser nginx -D && adduser nginx apache && adduser nginx $user &&\
    adduser $user apache && adduser $user nginx && adduser $user root &&\
    sed --in-place 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers &&\
    # YII 1.1.23
    mkdir -p /usr/share/php/ /var/data  /var/run/sphinx /run/php-fpm /var/log/sphinx /tmp/xdebug/profiler /tmp/xdebug/profiler && chmod 777 -R /var/data /tmp/xdebug/profiler /tmp/* &&\
    chown -R root /tmp && touch /tmp/xdebug.log && chmod 777 /tmp/xdebug.log &&\
    wget https://github.com/yiisoft/yii/releases/download/1.1.23/yii-1.1.23.445827.tar.gz -O - | tar -xz -C /usr/share/php/ && mv /usr/share/php/yii* /usr/share/php/yii1

# php ext
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions geoip mcrypt igbinary memcached gd gettext zip soap pdo pdo_mysql opcache @composer-2.0.2

# Get Composer
#COPY --from=composer /usr/bin/composer /usr/bin/composer
# copy configs
COPY common/php/php.ini /usr/local/etc/php/php.ini
COPY common/php/php-fpm.conf /etc/php-fpm.conf
COPY common/php/php-fpm.d /etc/php-fpm.d
COPY common/files/supervisord.conf /etc/supervisord.conf
COPY common/files/services.ini /etc/supervisord.d/services.ini
COPY common/files/sshd_config /etc/ssh/sshd_config
COPY common/files/sphinx.conf /etc/sphinx/sphinx.conf
COPY common/files/create_user.sh /usr/local/bin/create_user.sh

########################################################
#################### DEV ###############################
########################################################
FROM base AS dev
ENV XDEBUG_CONFIG='' XDEBUG_MODE='' create_user=deploy create_passwd=QWE123qwe
COPY common/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN pecl install xdebug && docker-php-ext-enable xdebug && echo 'Software version: ' > /etc/motd &&\
    php -v | head -n 1 >> /etc/motd &&\
    composer --version >> /etc/motd &&\
    searchd -h | head -n 1 >> /etc/motd &&\
    touch /tmp/xdebug.log && chown -R deploy:root /tmp/xdebug.log &&\
    chmod +x /usr/local/bin/create_user.sh &&\
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' &&\
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' &&\
    ssh-keygen -t ed25519 -f  /etc/ssh/ssh_host_ed25519_key -N '' &&\
    php -m 
EXPOSE 22 9001
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

########################################################
#################### PROD ###############################
########################################################
FROM base as prod
ENV SENTRY_ENVIRONMENT='' PHP_PM_MODE='' PHP_MAX_CHILDREN='' PHP_START_SERVERS='' PHP_MIN_SPARE_SERVERS='' PHP_MAX_SPARE_SERVERS='' MEMCACHED='' MEMCACHED1='' MEMCACHED2='' HOST_RESOLVER_DEFAULT_DOMAIN=''
EXPOSE 9001
ENTRYPOINT ["/usr/local/sbin/php-fpm","--nodaemonize","--fpm-config","/etc/php-fpm.conf"]




