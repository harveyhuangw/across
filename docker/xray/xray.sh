#!/bin/sh
#
# This is a Shell script for xray based alpine with Docker image
#
# Copyright (C) 2019 - 2020 Teddysun <i@teddysun.com>
#
# Reference URL:
# https://github.com/XTLS/Xray-core

PLATFORM=$1

if [ -z "$PLATFORM" ]; then
    ARCH="64"
else
    case "$PLATFORM" in
        linux/386)
            ARCH="32"
            ;;
        linux/amd64)
            ARCH="64"
            ;;
        linux/arm/v6)
            ARCH="arm32-v6"
            ;;
        linux/arm/v7)
            ARCH="arm32-v7a"
            ;;
        linux/arm64|linux/arm64/v8)
            ARCH="arm64-v8a"
            ;;
        linux/ppc64le)
            ARCH="ppc64le"
            ;;
        linux/s390x)
            ARCH="s390x"
            ;;
        *)
            ARCH=""
            ;;
    esac
fi

[ -z "${ARCH}" ] && echo "Error: Not supported OS Architecture" && exit 1

# Download the latest stable release
XRAY_FILE="Xray-linux-${ARCH}.zip"
XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/${XRAY_FILE}"

echo "Downloading release file: ${XRAY_FILE}"

wget -O "/tmp/${XRAY_FILE}" "${XRAY_URL}" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download release file: ${XRAY_FILE}"
    rm -f "/tmp/${XRAY_FILE}"
    exit 1
fi

echo "Download release file: ${XRAY_FILE} completed"

# Extract binary file
unzip -p "/tmp/${XRAY_FILE}" xray > /usr/bin/xray

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract binary file: xray"
    rm -f "/tmp/${XRAY_FILE}" /usr/bin/xray
    exit 1
fi

rm -f "/tmp/${XRAY_FILE}"

chmod +x /usr/bin/xray