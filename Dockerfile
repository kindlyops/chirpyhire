FROM ruby:2.6.2-alpine

RUN apk update && apk add build-base git nodejs postgresql-dev libxml2-dev tzdata qt5-qtwebkit-dev

# Install Yarn
ENV PATH=/root/.yarn/bin:$PATH
RUN apk add --virtual build-yarn curl && \
    touch ~/.bashrc && \
    curl -o- -L https://yarnpkg.com/install.sh | sh && \
    apk del build-yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
ENV QMAKE=/usr/lib/qt5/bin/qmake
RUN bundle install --binstubs --with test development

COPY . .

LABEL maintainer="Kindly Ops LLC <support@kindlyops.com>"

CMD puma -C config/puma.rb
