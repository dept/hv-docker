How to build and push the image

```
for node_version in 10 12 14 16; do
    docker build --build-arg RUBY_VERSION=$ruby_version --build-arg NODE_VERSION=$node_version--build-arg VERSION=0 -t hinderlingvolkart/node-build:$ruby_version-$node_version node-build/
    docker push hinderlingvolkart/node-build:$ruby_version-$node_version
done
```