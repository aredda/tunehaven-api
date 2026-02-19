# frozen_string_literal: true

# == Schema Information
#
# Table name: user_follows
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :uuid             not null
#  following_id :uuid             not null
#
# Indexes
#
#  index_user_follows_on_follower_and_following  (follower_id,following_id) UNIQUE
#  index_user_follows_on_follower_id             (follower_id)
#  index_user_follows_on_following_id            (following_id)
#
# Foreign Keys
#
#  fk_rails_...  (follower_id => users.id) ON DELETE => cascade
#  fk_rails_...  (following_id => users.id) ON DELETE => cascade
#
class User::Follow < ApplicationRecord
  belongs_to :follower, class_name: "User", inverse_of: :active_follows, counter_cache: :following_count
  belongs_to :following, class_name: "User", inverse_of: :passive_follows, counter_cache: :followers_count
end
