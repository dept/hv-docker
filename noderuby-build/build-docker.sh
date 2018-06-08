#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;

docker build -t hv-noderuby ./base
docker tag hv-noderuby hinderlingvolkart/noderuby-build
docker push hinderlingvolkart/noderuby-build
