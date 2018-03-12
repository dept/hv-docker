#!/bin/bash
cd node-build
./build-docker.sh
cd ..
cd noderuby-build
./build-docker.sh
cd ..
