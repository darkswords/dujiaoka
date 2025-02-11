FROM webdevops/php-nginx:7.4

COPY . /app
WORKDIR /app

# 移除架构条件判断，直接执行 composer install
RUN composer install --ignore-platform-reqs --no-plugins --no-scripts

RUN echo "#!/bin/bash\nphp artisan queue:work >/tmp/work.log 2>&1 &\nsupervisord" > /app/start.sh
RUN [ "sh", "-c", "chmod -R 777 /app" ]

CMD [ "sh", "-c","/app/start.sh" ]
