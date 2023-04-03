ARG RUBY_VERSION=latest

FROM ruby:${RUBY_VERSION}
WORKDIR /usr/src/app

ARG NODE_VERSION=14
ARG VERSION=0

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
	BUNDLER_VERSION="2.0"; \
	if [[ $(echo "$RUBY_VERSION < 2.6" | bc -l) -eq 1 ]]; then \
	BUNDLER_VERSION="2.3.26"; \
	fi; \
	gem install bundler -v "~>${BUNDLER_VERSION}"
RUN gem install bundler -v "~>1.0"
RUN \ 
	curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -; \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
	apt-get update -qq && apt-get install -qq --no-install-recommends \
	nodejs \
	yarn \
	pngquant \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*;
RUN \
	yarn global add @hv/publish; \
	hv-publish --version;

ENV CACHE_BUSTER ${VERSION}
RUN \ 
	yarn global add @hv/publish; \
	hv-publish --version;
