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
  context 'validations' do
    should have_db_column(:name)
    should have_db_column(:about)
  end
end
