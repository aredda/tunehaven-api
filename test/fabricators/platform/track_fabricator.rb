# frozen_string_literal: true

Fabricator :track, class_name: 'Platform::Track' do
  title { Faker::Music::RockBand.song }
end
