# == Schema Information
#
# Table name: user_playlists
#
#  id           :uuid             not null, primary key
#  description  :text
#  is_default   :boolean          default(FALSE)
#  likes_count  :integer          default(0)
#  title        :string           not null
#  tracks_count :integer          default(0)
#  visibility   :string           default("private")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class User::Playlist < ApplicationRecord
  alias_attribute :saves_count, :likes_count

  after_create :increment_if_public
  after_destroy :decrement_if_public
  after_update :handle_update, if: :saved_change_to_visibility?

  enum :visibility, { public: "public", private: "private" }, prefix: true

  belongs_to :user, class_name: "User", inverse_of: :playlists

  has_many :track_relationships, class_name: "User::PlaylistTrack", inverse_of: :playlist, dependent: :destroy, foreign_key: :playlist_id
  has_many :tracks, through: :track_relationships, source: :track

  has_many :user_saves, class_name: "User::Like", inverse_of: :likable, as: :likable, dependent: :destroy

  state_machine :visibility, initial: :private do
    event :toggle_visibility do
      transition public: :private
      transition private: :public
    end
  end

  def includes?(track) = tracks.include?(track)

  def increment_if_public
    user.increment!(:public_playlists_count) if visibility_public?
  end

  def decrement_if_public
    user.decrement!(:public_playlists_count) if visibility_public?
  end

  def handle_update
    if visibility_public?
      user.increment!(:public_playlists_count)
    else
      user.decrement!(:public_playlists_count)
    end
  end
end
