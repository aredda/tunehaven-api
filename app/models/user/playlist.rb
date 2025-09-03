# == Schema Information
#
# Table name: user_playlists
#
#  id           :uuid             not null, primary key
#  description  :text
#  is_default   :boolean          default(FALSE)
#  saves_count  :integer          default(0)
#  title        :string           not null
#  tracks_count :integer          default(0)
#  visibility   :string           default(NULL)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id) ON DELETE => cascade
#
class User::Playlist < ApplicationRecord
  enum :visibility, { public:, private: }, prefix: true

  belongs_to :user, class_name: "User", inverse_of: :playlists

  has_many :track_relationships, class_name: "User::PlaylistTrack", inverse_of: :playlist, dependent: :destroy, foreign_key: :playlist_id
  has_many :tracks, through: :track_relationships, source: :track

  has_many :user_saves, class_name: "User::PlaylistSave", inverse_of: :playlist, dependent: :destroy, foreign_key: :playlist_id

  state_machine :visibility, initial: :private do
    event :toggle_visibility do
      transition public: :private
      transition private: :public
    end
  end
end
