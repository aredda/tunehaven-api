# == Schema Information
#
# Table name: platform_album_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  album_id   :uuid
#  genre_id   :string
#
# Foreign Keys
#
#  fk_rails_...  (album_id => platform_albums.id)
#  fk_rails_...  (genre_id => platform_genres.id)
#
require "test_helper"

class Platform::AlbumGenreTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:album).class_name("Platform::Album")
  end
end
