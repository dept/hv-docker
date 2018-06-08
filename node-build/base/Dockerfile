FROM node:8
COPY bin/* /usr/local/bin/
WORKDIR /usr/src/app
RUN \
	chmod +x /usr/local/bin/*; \
	apt-get -y update && \
	apt-get install -y rsync zip pngquant jq; \
	echo "All done"
