# HV Frontend Prototype Deployment

We maintain docker images in this repository to make deployments of frontend prototypes as easy as a pancake. 
We currently have two images that both feature current stable Node JS (incl. Yarn). Another one comes with Ruby
support (for our Middleman based stacks).

Their main benefit is that they provide two very simple yet powerful commands:

## hv-publish and save2repo

see https://www.npmjs.com/package/@hv/publish

# Deployment

Build happens in dockerhub cloud on every commit to master.
If you need to go manual: install Docker, then just execute ```./build.sh```