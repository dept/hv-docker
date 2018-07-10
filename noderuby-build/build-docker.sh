#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;

docker build -t hinderlingvolkart/noderuby-build -t hinderlingvolkart/noderuby-build:latest -t hinderlingvolkart/noderuby-build:2-8 ./base
docker push hinderlingvolkart/noderuby-build
