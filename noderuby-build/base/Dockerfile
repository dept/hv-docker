FROM starefossen/ruby-node:2-8
COPY bin/* /usr/local/bin/
WORKDIR /usr/src/app
RUN \
	chmod +x /usr/local/bin/*; \
	gem update --system; gem install bundler --no-ri --no-rdoc; \
	apt-get -y update && \
	apt-get install -y rsync zip pngquant jq; \
	echo "All done"
