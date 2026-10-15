FROM ruby:4.0.7

# Install system dependencies first (changes rarely)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency files only (changes less frequently than app code)
COPY Gemfile Gemfile.lock ./

# Install gems including development and test groups
RUN bundle install --jobs 4 --retry 3

# Copy application code (changes most frequently)
COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0", "-e", "development"]
