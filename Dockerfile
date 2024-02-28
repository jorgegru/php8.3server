# Use a imagem oficial do PHP com Apache
FROM php:8.3-apache

# Atualizar lista de pacotes e instalar dependências
RUN apt-get update && \
    apt-get install -y \
    poppler-utils \
    libzip-dev \
    unzip \
    libonig-dev \
    libpq-dev \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libwebp-dev \
    libgmp-dev \
    libmagickwand-dev \
    libssl-dev

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Instalar extensões PHP necessárias
RUN docker-php-ext-install mbstring mysqli pdo_mysql xml
RUN docker-php-ext-install zip opcache gd soap gmp bcmath pcntl intl

# Instalar extensões adicionais
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Instale e ative a extensão Swoole
RUN pecl install swoole && \
    docker-php-ext-enable swoole

# Instalar o Imagick
RUN apt-get install -y libmagickwand-dev && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Instalar IMAP
RUN apt-get install -y libc-client-dev libkrb5-dev && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap

# Habilitar o JIT (Just-In-Time Compilation)
# Habilitar o JIT (Just-In-Time Compilation)
RUN echo "opcache.jit_buffer_size=100M" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.jit=1235" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini


# # CASO O REDIS esteja em conteiner saparado
# # Instalar o Redis e habilitar extensão
# RUN pecl install redis && \
#     docker-php-ext-enable redis

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar Git
RUN apt-get install -y git

# Configurar o Apache
# COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
# RUN a2enmod headers

# Reiniciar o Apache
RUN service apache2 restart

# # Definir o diretório de trabalho
# WORKDIR /var/www/html

# # Expor a porta 80
# EXPOSE 80

# # Comando padrão para iniciar o Apache
# CMD ["apache2-foreground"]