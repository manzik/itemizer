# We will use a ruby image with apline as base for a lightweight build
FROM ruby:3.0.2-alpine

# Install basic packages needed to run the container
RUN apk add --update --no-cache bash build-base nodejs tzdata postgresql-dev yarn less

# Init working directory
RUN mkdir /itemizer
WORKDIR /itemizer

# Install ruby gems and frontend packages
ENV BUNDLER_VERSION=2.3.5
RUN gem update --system
RUN gem install bundler -v $BUNDLER_VERSION
COPY Gemfile Gemfile.lock ./
RUN yarn install --check-files
RUN bundle install

COPY . .
EXPOSE 3000
ENTRYPOINT ["sh", "config/docker/entrypoint.sh"]