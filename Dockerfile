FROM ruby:2.4.1-alpine
# TODO update ruby

RUN apk update && apk add build-base git nodejs postgresql-dev libxml2-dev tzdata qt5-qtwebkit-dev

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler
ENV QMAKE=/usr/lib/qt5/bin/qmake
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Kindly Ops LLC <support@kindlyops.com>"

CMD puma -C config/puma.rb
