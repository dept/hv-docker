FROM debian
WORKDIR /usr/src/app
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && \
    apt-get install -qy procps curl ca-certificates gnupg2 build-essential --no-install-recommends && apt-get clean

RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.5"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.6"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.7"
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 3.0"
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -; \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list;
RUN /bin/bash -l -c "nvm install 10"
RUN /bin/bash -l -c "nvm install 12"
RUN /bin/bash -l -c "nvm install 14"
RUN /bin/bash -l -c "nvm install 15"
RUN /bin/bash -l -c "nvm install 16"
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
