FROM node:current-alpine
WORKDIR /usr/src/app
RUN \
	apk --no-cache --upgrade add git rsync zip pngquant jq \
	npm install -g git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git; \
	hv-publish --version; \
	echo "All done. Version 1.0.4"
CMD [ "npm", "update", "-g", "git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git" ]