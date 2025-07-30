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
end
