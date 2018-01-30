How to build and push the image

    docker build -t hv-node-build ./base
    docker tag hv-node-build hinderlingvolkart/node-build
    docker push hinderlingvolkart/node-build
