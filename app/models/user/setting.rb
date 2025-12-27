# frozen_string_literal: true

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
#  index_user_settings_on_user_id_and_key  (user_id,key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class User::Setting < ApplicationRecord
  belongs_to :user, inverse_of: :settings
end
