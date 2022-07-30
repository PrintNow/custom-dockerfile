#!/bin/bash

trap 'sig_handler' INT
sig_handler() {
  echo "Quit"
  exit 1
}

### Help function ###
echo_g() {
  [ $# -ne 1 ] && return 0
  echo -e "\033[32m$1\033[0m"
}

echo_b() {
  [ $# -ne 1 ] && return 0
  echo -e "\033[34m$1\033[0m"
}

### 构建命令
docker_build_push() {
  [ $# -ne 1 ] && return 0

  swoole_version="$1"
  http_proxy_url="http://127.0.0.1:7890"
  php_extensions="csv inotify"

  echo_b "开始构建镜像：$swoole_version"
  docker build \
    --build-arg HTTP_ROXY="$http_proxy_url" \
    --build-arg HTTPS_ROXY="$http_proxy_url" \
    --build-arg PHP_EXTENSIONS="$php_extensions" \
    --build-arg PHPSWOOLE_VERSION="$swoole_version" \
    -t shine09/php:"$swoole_version" .

  # 捕获是否异常
  [ $? -eq 0 ] || exit 1
  echo_g "构建镜像完成！\n"

  echo_b "开始推送镜像：$swoole_version"
  docker push shine09/php:"$swoole_version"
  echo_g "推送镜像完成！\n"
}

# 定义数组变量
declare -a PHPSWOOLE_VERSION_ARRAY
PHPSWOOLE_VERSION_ARRAY=(
  "4.8-php8.1-alpine"
  "4.8-php8.1"
  "4.8-php8.1-dev"
)

for version in ${PHPSWOOLE_VERSION_ARRAY[*]}; do
  docker_build_push "$version"
done
