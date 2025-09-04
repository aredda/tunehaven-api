# frozen_string_literal: true

class CreateUserAlbumSaves < ActiveRecord::Migration[8.0]
  def change
    create_table :user_album_saves do |t|
      t.uuid :user_id, null: false
      t.uuid :album_id, null: false

      t.foreign_key :users, column: :user_id
      t.foreign_key :platform_albums, column: :album_id

      t.index %i[user_id album_id], unique: true

      t.timestamps
    end
  end
end
