ARG PHPSWOOLE_VERSION
FROM phpswoole/swoole:${PHPSWOOLE_VERSION:-php8.1}
LABEL maintainer="Chuwen <i@nowtime.cc>" version="0.1"


ARG timezone
ENV TIMEZONE=${timezone:-"Etc/GMT"} \
    # APP_ENV=prod \
    SCAN_CACHEABLE=(true)

# PHP 扩展
ARG PHP_EXTENSIONS
ENV PHP_EXTENSIONS=${PHP_EXTENSIONS:-""}

# 一个安装 PHP 扩展的脚本
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# 安装扩展、设置时区
RUN install-php-extensions "${PHP_EXTENSIONS} pcntl redis pdo_mysql" \
    # - config timezone
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    # ---------- clear works ----------
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && rm -rf /var/www/html \
    # 服务类相关
    && rm -f /etc/supervisor/service.d/*.conf \
    # 任务类相关
    && rm -f /etc/supervisor/task.d/*.conf \
    # 最终会，汇聚到这个文件夹。也就是说在上面两个文件夹<服务类、任务类>创建的配置文件，都会同步到这里
    && rm -f /etc/supervisor/conf.d/*.conf \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
