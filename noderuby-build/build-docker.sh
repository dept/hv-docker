#!/bin/bash
cp ../shared-bin/* base/
docker build -t hv-noderuby ./base
docker tag hv-noderuby hinderlingvolkart/noderuby-build
docker push hinderlingvolkart/noderuby-build
