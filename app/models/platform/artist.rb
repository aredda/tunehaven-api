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
end
