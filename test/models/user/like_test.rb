# == Schema Information
#
# Table name: user_likes
#
#  id           :uuid             not null, primary key
#  likable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  likable_id   :uuid             not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_user_likes_on_likable_id_and_likable_type  (likable_id,likable_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class User::LikeTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:user)
    should belong_to(:likable)
  end
end
