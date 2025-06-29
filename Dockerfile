FROM php:7.4-fpm-alpine AS app

RUN apk add --no-cache nginx supervisor bash \
    php7-pdo php7-pdo_mysql php7-mbstring php7-opcache php7-xml php7-curl php7-bcmath php7-gd php7-exif php7-zip php7-fileinfo

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /app
WORKDIR /app

RUN composer install --ignore-platform-reqs

RUN echo "#!/bin/bash\nphp artisan queue:work > /tmp/work.log 2>&1 &\nsupervisord -n" > /app/start.sh && \
    chmod +x /app/start.sh && chmod -R 777 /app

CMD ["/app/start.sh"]
