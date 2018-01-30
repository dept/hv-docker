How to build and push the image

    docker build -t hv-noderuby ./base
    docker tag hv-noderuby hinderlingvolkart/noderuby-build
    docker push hinderlingvolkart/noderuby-build


    docker run -it -v $(pwd):/start-here -p 127.0.0.1:5000:4567 hv-noderuby bash

