# == Schema Information
#
# Table name: platform_track_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  genre_id   :string           not null
#  track_id   :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (genre_id => platform_genres.id)
#  fk_rails_...  (track_id => platform_tracks.id)
#
class Platform::TrackGenre < ApplicationRecord
  belongs_to :track, class_name: "Platform::Track", foreign_key: :track_id, inverse_of: :genre_relationships
end
