# frozen_string_literal: true

class CreateUserPlaylistSaves < ActiveRecord::Migration[8.0]
  def change
    create_table :user_playlist_saves do |t|
      t.uuid :user_id, null: false
      t.uuid :playlist_id, null: false

      t.timestamps

      t.foreign_key :users, column: :user_id
      t.foreign_key :user_playlists, column: :playlist_id

      t.index %i[user_id playlist_id], unique: true
    end

    add_column :user_playlists, :saves_count, :integer, default: 0
  end
end
