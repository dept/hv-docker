FROM starefossen/ruby-node:2-8-slim
WORKDIR /usr/src/app

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \ 
	apt-get update -qq \
	&& apt-get install -qq --no-install-recommends git build-essential pngquant \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*;
ENV CACHE_BUSTER v0
RUN \ 
	npm install -g --unsafe-perm=true @hv/publish; \
	hv-publish --version;
