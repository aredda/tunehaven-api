FROM ruby:3.4.4
WORKDIR /app
COPY Gemfile ./
RUN bundle install
COPY . .
EXPOSE $PORT
CMD ["bundle", "exec", "rails", "s", "-p", "$PORT", "-b", "0.0.0.0"]
