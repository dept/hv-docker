#!/bin/bash

docker build -t hinderlingvolkart/noderuby-build ./2-8
docker build -t hinderlingvolkart/noderuby-build:2.6-10 ./2-10
docker build -t hinderlingvolkart/noderuby-build:2.6-12 ./2-12
docker push hinderlingvolkart/noderuby-build
