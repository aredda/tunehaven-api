# frozen_string_literal: true

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
class Platform::Log::StorageSubEvent < ApplicationRecord
  enum :state, { processed: 0, succeeded: 1, failed: 2 }, prefix: true
  enum :type, { added: "OBJECT_FINALIZE", deleted: "OBJECT_DELETE" }, prefix: true

  state_machine initial: :processed
end
