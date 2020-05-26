#!/bin/bash
mkdir -p base/bin
find ../shared-bin -type f -not -iname '*.sh' -exec cp {} base/bin/ \;


docker build -t hinderlingvolkart/node-build -t hinderlingvolkart/node-build:current-alpine ./base
docker push hinderlingvolkart/node-build
