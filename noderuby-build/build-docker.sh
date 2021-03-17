#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;

docker build -t hinderlingvolkart/noderuby-build:2.6-10 ./base
docker build -t hinderlingvolkart/noderuby-build:2.6-12 ./2-12
docker push hinderlingvolkart/noderuby-build
