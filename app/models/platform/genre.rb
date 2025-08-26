# == Schema Information
#
# Table name: platform_genres
#
#  id          :string           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Platform::Genre < ApplicationRecord
  before_create :set_id

  def set_id
    self.id = name.parameterize
  end
end
