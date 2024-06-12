#!/bin/sh

native-image -Ob -H:+UnlockExperimentalVMOptions -H:+StaticExecutableWithDynamicLibC -m jdk.httpserver -o runner.mostly-static

# Distroless Base (provides glibc)
docker build . -f Dockerfile.distroless-base.mostly -t website-runner:distroless-base.mostly-static