# == Schema Information
#
# Table name: platform_track_audios
#
#  id          :uuid             not null, primary key
#  bitrate     :string
#  bucket_uri  :text
#  channels    :integer
#  duration    :integer
#  file        :string
#  format      :string
#  is_master   :boolean          default(FALSE)
#  method      :string           default("uploaded")
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
require "test_helper"

class Platform::Track::AudioTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:track).class_name("Platform::Track")
  end
end
