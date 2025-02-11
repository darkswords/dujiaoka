FROM webdevops/php-nginx:7.4

COPY . /app
WORKDIR /app

# 安装 Composer（避免模拟器问题）
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 使用 composer 安装依赖
RUN composer install --ignore-platform-reqs --no-plugins --no-scripts

RUN echo "#!/bin/bash\nphp artisan queue:work >/tmp/work.log 2>&1 &\nsupervisord" > /app/start.sh
RUN [ "sh", "-c", "chmod -R 777 /app" ]

CMD [ "sh", "-c","/app/start.sh" ]
