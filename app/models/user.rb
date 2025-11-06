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
class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: User::JwtDenylist

  after_create :create_default_playlist

  has_many :playlists, class_name: "User::Playlist", inverse_of: :user, dependent: :destroy
  has_one :liked_playlist, -> { where(is_default: true) }, class_name: "User::Playlist"

  has_many :album_saves, -> { where(likable_type: "Platform::Album") }, class_name: "User::Like", inverse_of: :user, dependent: :destroy, as: :likable
  has_many :saved_albums, through: :album_saves, source: :likable, source_type: "Platform::Album"

  has_many :playlist_saves, -> { where(likable_type: "User::Playlist") }, class_name: "User::Like", inverse_of: :user, as: :likable, dependent: :destroy
  has_many :saved_playlists, through: :playlist_saves, source: :likable, source_type: "User::Playlist"

  def create_default_playlist
    self.create_liked_playlist(title: "Liked")
  end

  def reset_password(new_password)
    self.password = new_password
    self.reset_password_token = nil
    self.reset_password_sent_at = nil

    save
  end

  def owns_playlist?(playlist) = playlists.include?(playlist)

  def saved_playlist?(playlist) = saved_playlists.include?(playlist)

  def likes_track?(track) = liked_playlist.tracks.include?(track)

  def saved_album?(album) = saved_albums.include?(album)
end
