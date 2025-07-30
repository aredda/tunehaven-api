# == Schema Information
#
# Table name: platform_artists
#
#  id         :uuid             not null, primary key
#  about      :text
#  name       :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class Platform::ArtistTest < ActiveSupport::TestCase
  context "validations" do
    should have_db_column(:name)
    should have_db_column(:about)
  end

  context "associations" do
    should have_many(:genre_relationships).class_name("Platform::ArtistGenre")
    should have_many(:albums).class_name("Platform::Album")
    should have_many(:tracks).class_name("Platform::Track")
  end
end
