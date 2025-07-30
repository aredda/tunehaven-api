# == Schema Information
#
# Table name: platform_genres
#
#  id          :string           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class Platform::GenreTest < ActiveSupport::TestCase
  context 'validations' do
    should have_db_column(:name)
    should have_db_column(:description)
  end
end
