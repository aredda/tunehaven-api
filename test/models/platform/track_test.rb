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
require "test_helper"

class Platform::TrackTest < ActiveSupport::TestCase
  context "validations" do
    should have_db_column(:title).of_type(:citext)
    should have_db_column(:duration_in_seconds).of_type(:integer)
  end

  context "associations" do
    should belong_to(:album).class_name("Platform::Album")
    should have_one(:artist).through(:album).class_name("Platform::Artist")

    should have_many(:genre_relationships).class_name("Platform::TrackGenre")
  end
end
