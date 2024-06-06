#!/bin/sh

rm -rf jlink-runner
jlink \
        --module-path ${JAVA_HOME}/jmods \
        --add-modules jdk.httpserver \
        --verbose \
        --strip-debug \
        --compress zip-9 \
        --no-header-files \
        --no-man-pages \
        --strip-java-debug-attributes \
        --output runner-jlink

# Distroless Java Base-provides glibc and other libraries needed by the JDK
docker build . -f Dockerfile.distroless-java-base.jlink -t website-runner:distroless-java-base.jlink