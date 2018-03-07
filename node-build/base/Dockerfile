FROM node:8
COPY hv-publish.sh /usr/local/bin/hv-publish
COPY aws-deploy.sh /usr/local/bin/aws-deploy
RUN \
	chmod 775 /usr/local/bin/aws-deploy; \
	chmod 775 /usr/local/bin/hv-publish; \
	apt-get -y update && \
	apt-get install -y zip gridsite-clients pngquant jq python3 python3-pip; \
	pip3 install --upgrade awscli; \
	echo "All done"
