# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = "https://1a537fc33600c024e13e2ec309b6a11b@o1428973.ingest.us.sentry.io/4510556573597696"
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

  # Add data like request headers and IP for users,
  # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
  config.send_default_pii = true
end
