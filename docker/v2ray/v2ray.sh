#!/bin/sh
#
# This is a Shell script for v2ray based alpine with Docker image
#
# Copyright (C) 2019 - 2022 Teddysun <i@teddysun.com>
#
# Reference URL:
# https://github.com/v2fly/v2ray-core.git

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
V2RAY_FILE="v2ray-linux-${ARCH}.zip"
V2RAY_URL="https://github.com/v2fly/v2ray-core/releases/latest/download/${V2RAY_FILE}"

echo "Downloading release file: ${V2RAY_FILE}"

wget -O "/tmp/${V2RAY_FILE}" "${V2RAY_URL}" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Error: Failed to download release file: ${V2RAY_FILE}"
    rm -f "/tmp/${V2RAY_FILE}"
    exit 1
fi

echo "Download release file: ${V2RAY_FILE} completed"

# Extract binary file
unzip -p "/tmp/${V2RAY_FILE}" v2ray > /usr/bin/v2ray

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract binary file: v2ray"
    rm -f "/tmp/${V2RAY_FILE}" /usr/bin/v2ray
    exit 1
fi

rm -f "/tmp/${V2RAY_FILE}"

chmod +x /usr/bin/v2ray