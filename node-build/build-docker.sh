#!/bin/bash
cp ../shared-bin/* base/
docker build -t hv-node ./base
docker tag hv-node hinderlingvolkart/node-build
docker push hinderlingvolkart/node-build
