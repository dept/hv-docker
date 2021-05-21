FROM debian
WORKDIR /usr/src/app
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -q && \
    apt-get install -qy procps curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s
RUN source /usr/local/rvm/scripts/rvm

SHELL ["/bin/bash", "-lc"]

RUN rvm install 2.5
RUN rvm install 2.6
RUN rvm install 2.7
RUN rvm install 3.0

RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list;

SHELL ["/bin/bash", "-lc"]
RUN nvm install 10
RUN nvm install 12
RUN nvm install 14
RUN nvm install 15
RUN nvm install 16
RUN \
	apt-get update -qq && \
	apt-get install -qq --no-install-recommends yarn pngquant;
RUN \
  apt-get clean \
  && rm -rf /var/lib/apt/lists/*;

ENV CACHE_BUSTER v0
RUN \ 
	yarn global add @hv/publish; \
	hv-publish --version;
ENTRYPOINT ["/bin/bash", "-l", "-c"]
