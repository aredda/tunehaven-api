# == Schema Information
#
# Table name: user_settings
#
#  id         :uuid             not null, primary key
#  key        :citext           not null
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_user_settings_on_key  (key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class User::SettingTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:user).class_name("User")
  end
end
