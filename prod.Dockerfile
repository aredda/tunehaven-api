FROM ruby:3.4.4

# Install system dependencies first (changes rarely)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency files only (changes less frequently than app code)
COPY Gemfile Gemfile.lock ./

# Install gems (cached unless Gemfile changes)
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy application code (changes most frequently)
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0", "-e", "production"]
