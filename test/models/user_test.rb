# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :citext           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  state                  :string
#  username               :citext           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "validations" do
    should have_db_column(:username)
    should have_db_column(:email)
    should have_db_column(:encrypted_password)
  end

  context "associations" do
    should have_many(:playlists).class_name("User::Playlist")
    should have_one(:liked_playlist).class_name("User::Playlist")
  end

  context "default playlist creation hook" do
    it "create a default playlist" do
      user = Fabricate(:user)

      assert_not_nil user.liked_playlist
      assert_equal "Liked", user.liked_playlist.title
      assert user.liked_playlist.is_default
    end
  end
end
