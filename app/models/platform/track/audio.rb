# == Schema Information
#
# Table name: platform_track_audios
#
#  id         :bigint           not null, primary key
#  bitrate    :string
#  file       :string
#  format     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  track_id   :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (track_id => platform_tracks.id)
#
class Platform::Track::Audio < ApplicationRecord
  belongs_to :track, class_name: "Platform::Track", inverse_of: :audios, foreign_key: :track_id
end
