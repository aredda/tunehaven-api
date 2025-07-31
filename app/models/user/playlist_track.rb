# == Schema Information
#
# Table name: user_playlist_tracks
#
#  id          :bigint           not null, primary key
#  position    :integer          default(1)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :uuid             not null
#  track_id    :uuid             not null
#
# Indexes
#
#  index_user_playlist_tracks_on_playlist_id_and_track_id  (playlist_id,track_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (playlist_id => user_playlists.id) ON DELETE => cascade
#  fk_rails_...  (track_id => platform_tracks.id) ON DELETE => cascade
#
class User::PlaylistTrack < ApplicationRecord
  belongs_to :playlist, class_name: 'User::Playlist', inverse_of: :track_relationships, foreign_key: :playlist_id
  belongs_to :track, class_name: 'Platform::Track'
end
