# == Schema Information
#
# Table name: platform_tracks
#
#  id                  :uuid             not null, primary key
#  audios_counter      :integer          default(0)
#  duration_in_seconds :integer
#  position            :integer
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

    should have_many(:audios).class_name("Platform::Track::Audio")
  end

  it "should assign position" do
    album = platform_albums(:ok_computer)

    album.tracks.order(created_at: :asc).each.with_index(1) do |track, index|
      track.update position: index
    end

    track = album.tracks.create(title: "The Tourist", duration_in_seconds: 300)

    assert_predicate track.position, :present?
    assert_equal album.tracks.count, track.position
  end
end
