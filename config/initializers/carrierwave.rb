# frozen_string_literal: true

CarrierWave.configure do |config|
  if not Rails.env.test?
    config.storage = :fog
    config.fog_credentials = {
      provider: "Google",
      google_project: ENV.fetch("GCS_PROJECT_NAME"),
      google_json_key_string: ENV.fetch("GOOGLE_CLOUD_CREDENTIALS")
    }
    config.fog_directory = ENV.fetch("GCS_BUCKET_NAME")
  else
    config.storage = :file
  end
end
