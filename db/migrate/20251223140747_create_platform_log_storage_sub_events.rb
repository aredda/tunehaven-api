# frozen_string_literal: true

class CreatePlatformLogStorageSubEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_log_storage_sub_events do |t|
      t.string :type, null: true
      t.string :filename, null: true
      t.integer :state, default: :processed
      t.string :error_message, null: true

      t.timestamps
    end
  end
end
