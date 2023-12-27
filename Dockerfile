FROM ruby:3.2.1

WORKDIR /usr/src/app

RUN gem install bundler

# If something changed in the lockfile, explode
RUN bundle config --global frozen 1

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application / source into the container
COPY ./app ./app
COPY ./bin ./bin
COPY ./config ./config
COPY ./db ./db
COPY ./lib ./lib
COPY ./public ./public
COPY config.ru .
COPY Rakefile .
COPY LICENSE .

CMD ["bash", "bin/run_production.sh"]
