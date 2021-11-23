#!/bin/bash

cd /usr/src/app/.bin

if [ "${LIBDRIVE_VERSION}" != "dev" ]; then
    if [ ! -z "${LIBDRIVE_VERSION}" ]; then
        if [ "${LIBDRIVE_VERSION}" = "latest" ]; then
            VER="latest"
        else
            VER="tags/${LIBDRIVE_VERSION}"
        fi
    else
        VER="latest"
    fi

    if [ ! -z "${LIBDRIVE_REPOSITRY}" ]; then
        REPO=${LIBDRIVE_REPOSITRY}
    else
        REPO="libDrive/libDrive"
    fi

    curl -L -s $(curl -s "https://api.github.com/repos/${REPO}/releases/${VER}" | grep -Po '"browser_download_url": "\K.*?(?=")') | tar xf - -C .

    pip3 install -r requirements.txt -q --no-cache-dir
else
    cd ./dev
fi

git clone https://github.com/shrey2199/LD_Meta_bot.git
cp -r LD_Meta_bot/helpers/ .
cp -r LD_Meta_bot/bot.py .
cp -r LD_Meta_bot/config.py .
cp -r LD_Meta_bot/requirements.txt ./botreq.txt
pip3 install -r requirements.txt -q --no-cache-dir
pip3 install -r botreq.txt
gunicorn main:app & python3 bot.py
