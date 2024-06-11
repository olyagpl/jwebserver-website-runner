#!/bin/sh

native-image -Ob --static-nolibc -m jdk.httpserver -o runner.mostly-static

# Distroless Base (provides glibc)
docker build . -f Dockerfile.distroless-base.mostly -t website-runner:distroless-base.mostly-static