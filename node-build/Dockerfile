ARG NODE_VERSION=14
FROM node:${NODE_VERSION}-alpine

WORKDIR /usr/src/app

ARG VERSION=0
RUN \
	apk add curl git;
RUN \
	yarn global add @hv/publish; \
	hv-publish --version;

ENV CACHE_BUSTER ${VERSION}
RUN \ 
	yarn global add @hv/publish; \
	hv-publish --version;
