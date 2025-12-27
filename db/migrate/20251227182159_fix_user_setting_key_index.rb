# frozen_string_literal: true

class FixUserSettingKeyIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :user_settings, column: :key
    add_index :user_settings, %i[user_id key], unique: true
  end
end
