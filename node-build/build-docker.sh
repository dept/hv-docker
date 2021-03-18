#!/bin/bash
docker build -t hinderlingvolkart/node-build ./10
docker build -t hinderlingvolkart/node-build:10 ./10
docker build -t hinderlingvolkart/node-build:12 ./12
docker build -t hinderlingvolkart/node-build:14 ./14
docker build -t hinderlingvolkart/node-build:15 ./15
docker push hinderlingvolkart/node-build
