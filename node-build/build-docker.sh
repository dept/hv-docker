#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;

docker build -t hv-node ./base
docker tag hv-node hinderlingvolkart/node-build
docker push hinderlingvolkart/node-build
