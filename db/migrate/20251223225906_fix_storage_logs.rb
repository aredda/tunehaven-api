# frozen_string_literal: true

class FixStorageLogs < ActiveRecord::Migration[8.0]
  def change
    rename_column :platform_log_storage_sub_events, :type, :event_type
    change_column :platform_log_storage_sub_events, :state, :string, default: :processed
  end
end
