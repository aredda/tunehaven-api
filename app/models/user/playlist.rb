# == Schema Information
#
# Table name: user_playlists
#
#  id           :uuid             not null, primary key
#  description  :text
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
  belongs_to :user, class_name: 'User', inverse_of: :playlists

  has_many :track_relationships, class_name: 'User::PlaylistTrack', inverse_of: :playlist, dependent: :destroy, foreign_key: :playlist_id
  has_many :tracks, through: :track_relationships, source: :track
end
