FROM ruby:3.4.4
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN apt-get update && apt-get install -y ffmpeg
EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
