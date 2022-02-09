FROM ruby:3.0.0-alpine

RUN apk update && apk add --no-cache --update build-base tzdata bash yarn python2 imagemagick graphviz mysql-dev mysql-client

WORKDIR /app
ENV LANG="ja_JP.UTF-8"

COPY Gemfile Gemfile.lock ./
RUN bundle install --no-cache

RUN apk add --no-cache gcompat libxml2 libxslt && \
  apk add --no-cache --virtual .gem-installdeps libxml2-dev libxslt-dev && \
  gem install nokogiri --platform=ruby -- --use-system-libraries && \
  rm -rf $GEM_HOME/cache && \
  apk del .gem-installdeps

# COPY package.json yarn.lock ./
# RUN yarn install && yarn cache clean

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]