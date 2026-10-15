FROM ruby:4.0.7

# Install system dependencies first (changes rarely)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to run the app
RUN groupadd --system --gid 1000 app && \
    useradd --system --uid 1000 --gid app --create-home --shell /bin/bash app

RUN mkdir -p /app && chown app:app /app
WORKDIR /app

# Copy dependency files only (changes less frequently than app code)
COPY --chown=app:app Gemfile Gemfile.lock ./

USER app
ENV HOME=/home/app \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Install gems into vendor/bundle (cached unless Gemfile changes)
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

# Copy application code (changes most frequently)
COPY --chown=app:app . .

# Ensure shell scripts are executable (handles both entrypoints)
RUN chmod +x *.sh

ENV RAILS_ENV=production

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-p", "3000", "-b", "0.0.0.0"]
