FROM ruby:2.6
WORKDIR /usr/src/app

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \ 
	curl -sL https://deb.nodesource.com/setup_10.x | bash -; \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list; \
	apt-get update -qq && apt-get install -qq --no-install-recommends \
    	nodejs \
    	yarn \
		pngquant \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*; \
	npm install -g @hv/publish; \
	hv-publish --version;
RUN \
	npm update -g @hv/publish; \ 
	echo "All done"
