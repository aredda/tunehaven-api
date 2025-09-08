# == Schema Information
#
# Table name: platform_tracks
#
#  id                  :uuid             not null, primary key
#  duration_in_seconds :integer          not null
#  title               :citext           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  album_id            :uuid
#
# Foreign Keys
#
#  fk_rails_...  (album_id => platform_albums.id)
#
class Platform::Track < ApplicationRecord
  belongs_to :album, class_name: "Platform::Album", foreign_key: :album_id, inverse_of: :tracks, counter_cache: :tracks_count
  has_one :artist, class_name: "Platform::Artist", through: :album, source: :artist

  has_many :genre_relationships, class_name: "Platform::TrackGenre", inverse_of: :track, dependent: :destroy
  has_many :genres, through: :genre_relationships, source: :genre

  has_many :audios, class_name: "Platform::Track::Audio", inverse_of: :track, dependent: :destroy
end
