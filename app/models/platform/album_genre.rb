# == Schema Information
#
# Table name: platform_album_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  album_id   :uuid
#  genre_id   :string
#
# Foreign Keys
#
#  fk_rails_...  (album_id => platform_albums.id)
#  fk_rails_...  (genre_id => platform_genres.id)
#
class Platform::AlbumGenre < ApplicationRecord
  belongs_to :album, class_name: "Platform::Album", foreign_key: :album_id, inverse_of: :genre_relationships
end
