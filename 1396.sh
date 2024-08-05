#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

if [[ ! $(id -u) == '0' ]]; then
    echo -e "${RED}需要 ROOT 权限${NC}"
    exit
fi

function install() {
    pkill httpd
    rm -rf /data/139
    mkdir /data/139
    if ! wget -q -O /data/139/httpd "https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv8l"; then
        echo -e "${RED}下载失败${NC}"
        exit 1
    fi
    chmod 755 /data/139/httpd
    /data/139/httpd -p 10005
    httpdstatus=$(ps -ef | grep httpd | grep -v grep | awk '{print $2}')
    if [[ $httpdstatus ]]; then
        echo -e "${GREEN}HTTP 服务启动成功${NC}"
    else
        echo -e "${RED}HTTP 服务启动失败${NC}"
        uninstall
        exit 1
    fi
}

function uninstall() {
    echo -e "${YELLOW}正在清理安装环境，请按回车继续...${NC}"
    read
    pkill httpd
    rm -rf /data/139
}

echo -e "${YELLOW}正在安装环境...${NC}"
install
ip=$(curl -s -4 ipinfo.io/ip)
echo -e "当前 IP: ${GREEN}${ip}${NC}"
echo "开始探测端口:"
echo -e "${YELLOW}请稍等...${NC}"
for port in {10000..10099}; do
    url="http://${ip}:${port}"
    status=$(curl --connect-timeout 0.1 --max-time 0.1 -o /dev/null -s -w "%{http_code}" "${url}")
    if [[ ${status} == '404' ]]; then
        echo -e "找到端口：${GREEN}${port}${NC}"
        break
    fi
done
if [[ ${port} ]]; then
    echo -e "端口：10002 ———— ${GREEN}$((${port} - 1))${NC}"
    echo -e "端口：10003 ———— ${GREEN}${port}${NC}"
    echo -e "端口：10004 ———— ${GREEN}$((${port} + 1))${NC}"
else
    echo '========================'
    echo -e "${RED}未找到可用端口${NC}"
fi
uninstall
