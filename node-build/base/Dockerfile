FROM node:8
WORKDIR /usr/src/app
RUN \
	apt-get -y update && \
	apt-get install -y rsync zip pngquant jq; \
	npm install -g git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git; \
	hv-publish --version; \ 
	echo "All done. Version 1.0.4"
CMD [ "npm", "update", "-g", "git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git" ]