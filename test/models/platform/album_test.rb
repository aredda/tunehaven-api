# == Schema Information
#
# Table name: platform_albums
#
#  id           :uuid             not null, primary key
#  cover        :string
#  release_date :date
#  slug         :citext
#  title        :citext           not null
#  tracks_count :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  artist_id    :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => platform_artists.id)
#
require "test_helper"

class Platform::AlbumTest < ActiveSupport::TestCase
  context "validations" do
    should have_db_column(:title)
    should have_db_column(:cover)
    should have_db_column(:tracks_count)
    should have_db_column(:release_date)
    should have_db_column(:artist_id)
  end

  context "associations" do
    should belong_to(:artist).class_name("Platform::Artist")

    should have_many(:genre_relationships).class_name("Platform::AlbumGenre")
    should have_many(:tracks).class_name("Platform::Track")
  end
end
