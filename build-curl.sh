#!/bin/sh
set -e

apk update && apk add build-base perl linux-headers

wget https://github.com/openssl/openssl/archive/refs/tags/openssl-3.0.9.tar.gz
tar -zxf openssl-3.0.9.tar.gz
cd openssl-openssl-3.0.9/
./Configure --prefix=/opt/openssl-3.0.9-linux-musl-arm64
make -j$(nproc)
make install
cd ..

wget https://curl.se/download/curl-8.8.0.tar.gz
tar -zxf curl-8.8.0.tar.gz
cd curl-8.8.0/
# Static linking with libcurl but dynamic linking with other libraries (openssl and libc).
./configure \
    --with-openssl=/opt/openssl-3.0.9-linux-musl-arm64 \
    --prefix=/opt/curl-8.8.0-linux-musl-arm64 \
    --enable-static \
    --disable-shared \
    --with-ca-bundle=/etc/ssl/certs/cacert.pem \
    --with-ca-path=/etc/ssl/certs
make -j$(nproc)
make install
cp COPYING /opt/curl-8.8.0-linux-musl-arm64/

cd /opt
tar -zcf curl-8.8.0-linux-musl-arm64.tar.gz curl-8.8.0-linux-musl-arm64
