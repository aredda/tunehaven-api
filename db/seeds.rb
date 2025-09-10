# frozen_string_literal: true

# Seed an admin
AdminUser.create(email: ENV.fetch('ADMIN_EMAIL'), password: ENV.fetch('ADMIN_PASSWORD'))

# Seed Music Genres
ActiveRecord::Base.transaction do
  Platform::Genre.create(JSON.parse(File.read(Rails.root.join("db", "seed/genres.json"))))
end
