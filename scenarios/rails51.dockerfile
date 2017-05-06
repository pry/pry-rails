FROM ruby:2.4
RUN mkdir -p /scenario
WORKDIR /scenario
ENV LANG=C.UTF-8
CMD (bundle check || bundle install) && bundle exec rake
