# == Schema Information
#
# Table name: platform_albums
#
#  id           :uuid             not null, primary key
#  cover        :string
#  release_date :date
#  slug         :citext
#  title        :citext           not null
#  tracks_count :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  artist_id    :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (artist_id => platform_artists.id)
#
class Platform::Album < ApplicationRecord
  mount_uploader :cover, CoverUploader

  before_create :set_slug

  belongs_to :artist, class_name: "Platform::Artist", foreign_key: :artist_id, inverse_of: :albums, counter_cache: :albums_count

  has_many :genre_relationships, class_name: "Platform::AlbumGenre", foreign_key: :album_id, dependent: :destroy, inverse_of: :album
  has_many :genres, through: :genre_relationships, source: :genre

  has_many :tracks, -> { order(position: :asc) }, class_name: "Platform::Track", foreign_key: :album_id, inverse_of: :album, dependent: :destroy

  has_many :user_saves, class_name: "User::Like", inverse_of: :likable, as: :likable

  def set_slug
    self.slug = [ artist.slug, title ].join("-").parameterize unless slug.present?
  end
end
