#!/bin/sh 

./build-jlink-runner.sh
./build-dynamic-runner.sh
./build-mostly-static-runner.sh
./build-static-runner.sh
./build-static-compressed-runner.sh

echo "Generated Executables"
ls -lh runner*

echo "Generated Docker Container Images"
docker images website-runner
