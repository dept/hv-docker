FROM node:15
WORKDIR /usr/src/app
ENV CACHE_BUSTER v0
RUN \
	npm install -g --unsafe-perm=true @hv/publish; \
	hv-publish --version; \
CMD [ "npm", "update", "-g", "@hv/publish" ]