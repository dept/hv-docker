# HV Frontend Prototype Deployment

We maintain docker images in this repository to make deployments of frontend prototypes as easy as a pancake.
We currently have two images that both feature current stable Node JS (incl. Yarn). Another one comes with Ruby
support (for our Middleman based stacks).

Their main benefit is that they provide two very simple yet powerful commands:

## hv-publish and save2repo

see https://www.npmjs.com/package/@hv/publish

# Deployment

Build happens in dockerhub cloud on every commit to master.
If you need to go manual: install Docker, then just execute `./build.sh`

# Usage (as of April 4, 2023)

node-build

Not used: 18 15 14 12 10
Used lately: 16

noderuby-build

Not used: 3-16 3-14 3-12 3-10 2-16 3.0-16 3.0-14 3.0-12 3.0-10 2.7-16 2.6-14 2.6-12 2.6-10 2.5-16
Used lately: 2-14 2-12 2-10 2.7-14 2.7-12 2.7-10 2.6-16 2.5-14 2.5-12 2.5-10 2-8 2.5-lts
