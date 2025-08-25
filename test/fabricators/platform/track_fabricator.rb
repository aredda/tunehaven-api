# frozen_string_literal: true

# == Schema Information
#
# Table name: platform_tracks
#
#  id                  :uuid             not null, primary key
#  duration_in_seconds :integer          not null
#  title               :citext           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  album_id            :uuid
#
# Foreign Keys
#
#  fk_rails_...  (album_id => platform_albums.id)
#
Fabricator :track, class_name: 'Platform::Track' do
  title { Faker::Music::RockBand.song }
end
