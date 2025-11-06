# frozen_string_literal: true

class CreateUserLikes < ActiveRecord::Migration[8.0]
  def change
    create_table :user_likes, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :likable_id, null: false
      t.string :likable_type, null: false

      t.foreign_key :users, column: :user_id
      t.index %i[likable_id likable_type], unique: true

      t.timestamps
    end
  end
end
