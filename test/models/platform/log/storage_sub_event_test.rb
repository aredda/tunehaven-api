# == Schema Information
#
# Table name: platform_log_storage_sub_events
#
#  id            :bigint           not null, primary key
#  error_message :string
#  filename      :string
#  state         :integer
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class Platform::Log::StorageSubEventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
