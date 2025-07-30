# == Schema Information
#
# Table name: platform_track_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  genre_id   :string           not null
#  track_id   :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (genre_id => platform_genres.id)
#  fk_rails_...  (track_id => platform_tracks.id)
#
require "test_helper"

class Platform::TrackGenreTest < ActiveSupport::TestCase
  context 'associations' do
    should belong_to(:track).class_name('Platform::Track')
  end
end
