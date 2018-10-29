FROM ruby:2.5.3
MAINTAINER Donapieppo <donapieppo@yahoo.it>

# ENV DEBIAN_FRONTEND noninteractive

ENV CPKG_SECRET_KEY_BASE 28ee1481f4376882211efcac2abb2473cc6af6baf86b54ca54605b99bf0109250c7d6c771b9ee1fdfc9aa6442342ab6ab1343dd845a2a5bc8287ec40e5186e36
ENV CPKG_BASEDIR /home/rails/cpkg-on-rails
ENV CPKG_DATABASE_PASSWORD secret_cpkg_maria_root_password

# the matiadb serverf is on docker-compose.yml
RUN apt-get update \
    && apt-get install -y -y --no-install-recommends mariadb-client libmariadbclient-dev apt-utils debhelper reprepro \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/rails/cpkg-on-rails
WORKDIR /home/rails/cpkg-on-rails
COPY . .
COPY doc/docker/Gemfile_docker      ./Gemfile
COPY doc/docker/Gemfile_docker.lock ./Gemfile.lock
COPY db/schema.rb                   ./db/schema.rb  
RUN bundle install

# configuration
RUN ["/bin/cp", "doc/docker/dm_unibo_common_docker.yml", "config/dm_unibo_common.yml"]
RUN ["/bin/cp", "doc/docker/cpkg_example_docker.rb",     "config/initializers/cpkg.rb"]

# see docker-compose.yml
#RUN ["rake", "db:create"]
#RUN ["rake", "db:schema:load"]

#EXPOSE 3000
#CMD ["rails", "server", "-b", "0.0.0.0"]



