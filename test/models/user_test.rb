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
#  followers_count        :integer          default(0)
#  following_count        :integer          default(0)
#  public_playlists_count :integer          default(0)
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

    should have_many(:playlist_saves).class_name("User::Like")
    should have_many(:saved_playlists).class_name("User::Playlist").through(:playlist_saves)

    should have_many(:album_saves).class_name("User::Like")
    should have_many(:saved_albums).through(:album_saves)

    should have_many(:settings).class_name("User::Setting")
    should have_one(:quality_setting).class_name("User::Setting")

    should have_many(:active_follows).class_name("User::Follow")
    should have_many(:passive_follows).class_name("User::Follow")

    should have_many(:followers).class_name("User").through(:passive_follows)
    should have_many(:following).class_name("User").through(:active_follows)
  end

  context "hooks" do
    let(:user) { Fabricate(:user) }

    it "should create a default playlist" do
      assert_not_nil user.liked_playlist
      assert_equal "Liked", user.liked_playlist.title
      assert user.liked_playlist.is_default
    end
    it "should create default settings" do
      assert_not_equal 0, user.settings.count
      assert_includes user.settings.pluck(:key), "quality"
    end
  end

  context "follow functionality" do
    let(:user1) { Fabricate(:user, followers_count: 0, following_count: 0) }
    let(:user2) { Fabricate(:user, followers_count: 0, following_count: 0) }

    it "should follow another user" do
      assert_difference -> { user1.following.count }, 1 do
        assert_difference -> { user2.followers_count }, 1 do
          user1.follow(user2)
        end
      end

      assert user1.following?(user2)
      assert user2.followed_by?(user1)

      user1.reload
      user2.reload

      assert_equal 1, user1.following_count
      assert_equal 1, user2.followers_count
    end

    it "should unfollow another user" do
      user1.follow(user2)

      assert_difference -> { user1.following.count }, -1 do
        assert_difference -> { user2.followers.count }, -1 do
          user1.unfollow(user2)
        end
      end

      assert_not user1.following?(user2)
      assert_not user2.followed_by?(user1)

      user1.reload
      user2.reload

      assert_equal 0, user1.following_count
      assert_equal 0, user2.followers_count
    end

    it "should not follow self" do
      assert_raises("A user cannot follow himself") do
        user1.follow(user1)
      end

      assert_equal 0, user1.following_count
      assert_equal 0, user1.followers_count
    end

    it "should not allow duplicate follows" do
      user1.follow(user2)

      assert_raises("Already followed") do
        user1.follow(user2)
      end

      user1.reload
      user2.reload

      assert_equal 1, user1.following_count
      assert_equal 1, user2.followers_count
    end

    it "should handle unfollow non-existent relationship gracefully" do
      assert_no_difference -> { user1.following.count } do
        assert_no_difference -> { user2.following_count } do
          result = user1.unfollow(user2)

          assert_nil result
        end
      end
    end
  end
end
