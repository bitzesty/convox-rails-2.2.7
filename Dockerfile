FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  libcurl4-openssl-dev \
  liblzma-dev \
  libmysqld-dev \
  libpq-dev \
  libsqlite3-dev \
  nodejs \
  rbenv \
  ruby-build \
  ruby-dev \
  tzdata \
  zlib1g-dev \
  libfreetype6 \ 
  libfreetype6-dev \
  libfontconfig1 \
  libfontconfig1-dev

ARG RUBY_VERSION=2.2.7
ENV PATH /root/.rbenv/shims:${PATH}
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && rbenv install ${RUBY_VERSION} \
  && rbenv global ${RUBY_VERSION}

ARG BUNDLER_VERSION=1.14.6
RUN gem install bundler -v ${BUNDLER_VERSION} && rbenv rehash

ARG NODE_VERSION=7.7.1
ENV NVM_DIR=/root/.nvm
ENV PATH /root/.nvm/versions/node/v${NODE_VERSION}/bin:${PATH}
RUN curl -s https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash \
  && . /root/.nvm/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default

ARG PHANTOM_JS_VERSION=2.1.1
RUN git clone https://github.com/ariya/phantomjs.git /tmp/phantomjs \
  && cd /tmp/phantomjs \
  && git checkout ${PHANTOM_JS_VERSION} \
  && ./build.sh --confirm \ 
  && mv bin/phantomjs /usr/local/bin \
  && rm -rf /tmp/phantomjs


WORKDIR /app

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
