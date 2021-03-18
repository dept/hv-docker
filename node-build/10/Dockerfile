FROM node:10
WORKDIR /usr/src/app
RUN \
	npm install -g --unsafe-perm=true @hv/publish; \
	hv-publish --version; \
	echo "All done. Version 1.0.6"
CMD [ "npm", "update", "-g", "@hv/publish" ]