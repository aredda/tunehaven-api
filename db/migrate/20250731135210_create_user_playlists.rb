# frozen_string_literal: true

class CreateUserPlaylists < ActiveRecord::Migration[8.0]
  def change
    create_table :user_playlists, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :title, null: false
      t.text :description, null: true
      t.string :visibility, default: :private
      t.integer :tracks_count, default: 0

      t.foreign_key :users, column: :user_id, on_delete: :cascade

      t.timestamps
    end
  end
end
