ARG RUBY_IMAGE_TAG=2.7-slim
FROM docker.io/library/ruby:${RUBY_IMAGE_TAG}

WORKDIR /opt/PasswordPusher

# Require a build date to ensure OS patches are routinely applied
ARG apt_update_date

RUN apt-get update \
 && apt-get upgrade --yes \
 && apt-get install --yes \
      build-essential \
      curl \
      libpq-dev \
      nodejs \
      tzdata \
      yarnpkg \
      zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && gem install bundler

ARG authors
ARG url
ARG build-timestamp
ARG ref
ARG revision
ARG version

LABEL org.opencontainers.image.authors="$authors"
LABEL org.opencontainers.image.base.name="docker.io/library/ruby:$NGINX_IMAGE_TAG"
LABEL org.opencontainers.image.created="$build-timestamp"
LABEL org.opencontainers.image.description="Updater's Password Pusher service"
LABEL org.opencontainers.image.ref.name="$ref"
LABEL org.opencontainers.image.revision="$revision"
LABEL org.opencontainers.image.title="password-pusher"
LABEL org.opencontainers.image.url="$url"
LABEL org.opencontainers.image.vendor="Updater"
LABEL org.opencontainers.image.version="$version"

ENV BUILD_TIMESTAMP=$build-timestamp
ENV VERSION=$version
ENV PORT=80

ENV FORCE_SSL=true
ENV RACK_ENV=production
ENV RAILS_ENV=production

COPY Gemfile Gemfile.lock ./

RUN bundle config set without 'development test' \
 && bundle config set deployment 'true' \
 && bundle install

COPY ./ ./

RUN bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
