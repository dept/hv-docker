FROM node:16-alpine
WORKDIR /usr/src/app
RUN \
	apk add curl git;
ENV CACHE_BUSTER v0
RUN \
	npm install -g --unsafe-perm=true @hv/publish; \
	hv-publish --version;