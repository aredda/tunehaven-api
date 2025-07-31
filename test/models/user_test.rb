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
require "test_helper"

class UserTest < ActiveSupport::TestCase
  context 'validations' do
    should have_db_column(:username)
    should have_db_column(:email)
    should have_db_column(:password)
  end

  context 'associations' do
    should have_many(:playlists).class_name('User::Playlist')
  end
end
