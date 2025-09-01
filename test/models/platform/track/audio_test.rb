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
require "test_helper"

class Platform::Track::AudioTest < ActiveSupport::TestCase
  context "associations" do
    should belong_to(:track).class_name("Platform::Track")
  end
end
