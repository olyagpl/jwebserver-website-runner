#!/bin/sh
set +e

rm -rf runner-jlink/
rm runner.dynamic runner.mostly-static runner.static runner.static-upx
rm -rf svm*.md
docker images website-runner -q | grep -v TAG | awk '{print($1)}' | xargs docker rmi