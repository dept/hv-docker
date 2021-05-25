FROM ruby:2.7
WORKDIR /usr/src/app

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN gem install bundler -v "~>1.0"
RUN \ 
	curl -sL https://deb.nodesource.com/setup_14.x | bash -; \
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
ENV CACHE_BUSTER v0
RUN \ 
	yarn global add @hv/publish; \
	hv-publish --version;
