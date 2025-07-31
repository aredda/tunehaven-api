# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  email      :citext           not null
#  password   :string           not null
#  state      :string
#  username   :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :playlists, class_name: 'User::Playlist', inverse_of: :user, dependent: :destroy
end
