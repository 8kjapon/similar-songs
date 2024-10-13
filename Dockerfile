# Rubyのバージョン指定
ARG RUBY_VERSION=ruby:3.2.5

# Nodeのバージョン指定
ARG NODE_VERSION=18

FROM $RUBY_VERSION
ARG RUBY_VERSION
ARG NODE_VERSION
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -qq \
&& apt-get install -y build-essential nodejs yarn
RUN mkdir /similar-songs
WORKDIR /similar-songs
RUN gem install bundler -v 2.4.22
COPY Gemfile /similar-songs/Gemfile
COPY Gemfile.lock /similar-songs/Gemfile.lock
COPY yarn.lock /similar-songs/yarn.lock
RUN bundle install
RUN yarn install
COPY . /similar-songs