FROM webdevops/php-nginx:7.4

COPY . /app
WORKDIR /app

# 针对 ARM 架构使用 --no-plugins 和 --no-scripts
RUN [ "sh", "-c", "if [ $(uname -m) = 'aarch64' ]; then composer install --ignore-platform-reqs --no-plugins --no-scripts; else composer install --ignore-platform-reqs; fi" ]

RUN echo "#!/bin/bash\nphp artisan queue:work >/tmp/work.log 2>&1 &\nsupervisord" > /app/start.sh
RUN [ "sh", "-c", "chmod -R 777 /app" ]

CMD [ "sh", "-c","/app/start.sh" ]
