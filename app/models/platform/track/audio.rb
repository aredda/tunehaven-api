# == Schema Information
#
# Table name: platform_track_audios
#
#  id          :uuid             not null, primary key
#  bitrate     :string
#  channels    :integer
#  duration    :integer
#  file        :string
#  format      :string
#  is_master   :boolean          default(FALSE)
#  quality     :string           default("low")
#  sample_rate :integer
#  size        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  track_id    :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (track_id => platform_tracks.id)
#
class Platform::Track::Audio < ApplicationRecord
  mount_uploader :file, Platform::Track::AudioUploader

  enum :quality, { original: "original", low: "low", mid: "mid", high: "high" }, prefix: true

  belongs_to :track, class_name: "Platform::Track", inverse_of: :audios, foreign_key: :track_id, counter_cache: :audios_count
end
