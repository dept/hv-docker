FROM node:14
WORKDIR /usr/src/app
RUN \
	npm install -g @hv/publish; \
	hv-publish --version; \
	echo "All done. Version 1.0.6"
CMD [ "npm", "update", "-g", "@hv/publish" ]