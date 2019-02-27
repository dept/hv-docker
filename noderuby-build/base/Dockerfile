FROM starefossen/ruby-node:2-8
WORKDIR /usr/src/app
RUN \
	gem update --system; gem install bundler --no-ri --no-rdoc; \
	apt-get -y update && \
	apt-get install -y rsync zip pngquant jq; \
	npm install -g git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git; \ 
	echo "All done"
CMD [ "npm", "update", "-g", "git+https://git@bitbucket.org/hinderlingvolkart/hv-publish.git" ]