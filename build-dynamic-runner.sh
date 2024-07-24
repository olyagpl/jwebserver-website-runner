#!/bin/sh

# compile with fully dynamically linked shared libraries
native-image -Os -m jdk.httpserver -o runner.dynamic

# Distroless Java Base-provides glibc and other libraries needed by the JDK
docker build . -f Dockerfile.distroless-java-base.dynamic -t website-runner:distroless-java-base.dynamic