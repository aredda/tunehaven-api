# == Schema Information
#
# Table name: platform_genres
#
#  id          :string           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :string
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => platform_genres.id)
#
require "test_helper"

class Platform::GenreTest < ActiveSupport::TestCase
  context "validations" do
    should have_db_column(:name)
    should have_db_column(:description)
  end

  context "associations" do
    should belong_to(:parent_genre).class_name("Platform::Genre").optional(true)
    should have_many(:child_genres).class_name("Platform::Genre")
  end
end
