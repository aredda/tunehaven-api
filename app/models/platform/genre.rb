# == Schema Information
#
# Table name: platform_genres
#
#  id          :string           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  parent_id   :string
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => platform_genres.id)
#
class Platform::Genre < ApplicationRecord
  before_create :set_id

  belongs_to :parent_genre, class_name: "Platform::Genre", inverse_of: :child_genres, foreign_key: :parent_id, optional: true
  has_many :child_genres, class_name: "Platform::Genre", inverse_of: :parent_genre, dependent: :destroy

  has_many :album_relationships, class_name: "Platform::AlbumGenre", dependent: :destroy, foreign_key: :genre_id
  has_many :albums, through: :album_relationships, source: :album

  def set_id
    self.id = name.parameterize
  end
end
