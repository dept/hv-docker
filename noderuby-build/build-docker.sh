#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;

docker build -t hinderlingvolkart/noderuby-build:2-10 ./base
docker push hinderlingvolkart/noderuby-build
