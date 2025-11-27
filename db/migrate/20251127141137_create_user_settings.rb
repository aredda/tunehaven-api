# frozen_string_literal: true

class CreateUserSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :user_settings, id: :uuid do |t|
      t.uuid    :user_id, null: false
      t.citext  :key, null: false
      t.string  :value, null: false

      t.foreign_key :users, column: :user_id

      t.index :key, unique: true

      t.timestamps
    end
  end
end
