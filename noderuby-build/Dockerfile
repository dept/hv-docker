ARG RUBY_VERSION=latest

FROM ruby:${RUBY_VERSION}
WORKDIR /usr/src/app

ARG NODE_VERSION=14
ARG VERSION=0
ARG BUNDLER_VERSION=2.0

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY install-node.sh /usr/local/bin/install-node.sh
RUN chmod +x /usr/local/bin/install-node.sh

RUN \
	gem install bundler -v "~>${BUNDLER_VERSION}"; \
	gem install bundler -v "~>1.0"
RUN /usr/local/bin/install-node.sh
RUN \
	yarn global add @hv/publish; \
	hv-publish --version;

ENV CACHE_BUSTER ${VERSION}
RUN \ 
	yarn global add @hv/publish; \
	hv-publish --version;
