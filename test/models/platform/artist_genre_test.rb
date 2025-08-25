# == Schema Information
#
# Table name: platform_artist_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  artist_id  :uuid             not null
#  genre_id   :string           not null
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => platform_artists.id)
#  fk_rails_...  (genre_id => platform_genres.id)
#
require "test_helper"

class Platform::ArtistGenreTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:artist).class_name("Platform::Artist")
  end
end
