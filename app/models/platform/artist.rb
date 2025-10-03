# == Schema Information
#
# Table name: platform_artists
#
#  id           :uuid             not null, primary key
#  about        :text
#  albums_count :integer          default(0)
#  name         :citext           not null
#  slug         :citext
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Platform::Artist < ApplicationRecord
  before_create :set_slug

  has_many :genre_relationships, class_name: "Platform::ArtistGenre", foreign_key: :artist_id, inverse_of: :artist, dependent: :destroy
  has_many :genres, through: :genre_relationships, source: :genre

  has_many :albums, -> { order(release_date: :desc) }, class_name: "Platform::Album", inverse_of: :artist, dependent: :destroy
  has_many :tracks, class_name: "Platform::Track", through: :albums, inverse_of: :artist, dependent: :destroy

  def set_slug
    self.slug = name.parameterize
  end
end
