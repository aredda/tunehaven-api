# frozen_string_literal: true

# == Schema Information
#
# Table name: platform_log_storage_sub_events
#
#  id            :bigint           not null, primary key
#  error_message :string
#  event_type    :string
#  filename      :string
#  state         :string           default("processed")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Platform::Log::StorageSubEvent < ApplicationRecord
  enum :event_type, { added: "OBJECT_FINALIZE", deleted: "OBJECT_DELETE" }, prefix: true

  state_machine :state, initial: :processed do
    state :processed
    state :succeeded
    state :failed
  end
end
