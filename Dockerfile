# https://docs.docker.com/compose/rails/
FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY vendor /myapp/vendor
RUN bundle install
COPY . /myapp
RUN rm -rf /myapp/tmp/ && mkdir -p /myapp/tmp/

CMD ["/myapp/startup.sh"]
