# == Schema Information
#
# Table name: platform_artists
#
#  id         :uuid             not null, primary key
#  about      :text
#  name       :citext           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Platform::Artist < ApplicationRecord
  has_many :genre_relationships, class_name: "Platform::ArtistGenre", foreign_key: :artist_id, inverse_of: :artist, dependent: :destroy
  has_many :genres, through: :genre_relationships, source: :genre

  has_many :albums, class_name: "Platform::Album", inverse_of: :artist, dependent: :destroy
  has_many :tracks, class_name: "Platform::Track", through: :albums, inverse_of: :artist, dependent: :destroy
end
