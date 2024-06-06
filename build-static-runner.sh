#!/bin/sh

TOOLCHAIN_DIR=`pwd`/x86_64-linux-musl-native
CC=${TOOLCHAIN_DIR}/bin/gcc
PATH=${TOOLCHAIN_DIR}/bin:${PATH}

native-image -Ob --static --libc=musl -m jdk.httpserver -o runner.static

# Scratch-nothing
docker build . -f Dockerfile.scratch.static -t website-runner:scratch.static

# Alpine-no glibc
# docker build . -f Dockerfile.alpine.static -t website-runner:alpine.static