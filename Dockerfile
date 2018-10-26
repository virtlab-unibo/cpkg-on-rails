FROM ruby:2.5.3
MAINTAINER Donapieppo <donapieppo@yahoo.it>

ENV DEBIAN_FRONTEND noninteractive

ENV CPKG_SECRET_KEY_BASE 28ee1481f4376882211efcac2abb2473cc6af6baf86b54ca54605b99bf0109250c7d6c771b9ee1fdfc9aa6442342ab6ab1343dd845a2a5bc8287ec40e5186e36
ENV CPKG_DATABASE_PASSWORD veryveryverysecret
ENV CPKG_BASEDIR /home/rails/cpkg-on-rails

RUN apt-get update \
    && apt-get install -y -y --no-install-recommends sqlite3 apt-utils debhelper reprepro \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/rails/cpkg-on-rails
WORKDIR /home/rails/cpkg-on-rails
COPY Gemfile* ./
RUN bundle install
COPY . .

# configuration
RUN ["/bin/cp", "doc/dm_unibo_common_docker.yml", "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/cpkg_example_docker.rb",     "config/initializers/cpkg.rb"]
# RUN ["/bin/cp", "doc/sqlite_database.yml",        "config/database.yml"]

# db
RUN ["rake", "db:create"]
RUN ["rake", "db:schema:load"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]



