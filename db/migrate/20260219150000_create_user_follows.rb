# frozen_string_literal: true

class CreateUserFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :user_follows do |t|
      t.uuid :follower_id, null: false, index: true
      t.uuid :following_id, null: false, index: true

      t.timestamps null: false

      t.index [ :follower_id, :following_id ], unique: true, name: "index_user_follows_on_follower_and_following"
      t.foreign_key :users, column: :follower_id, on_delete: :cascade
      t.foreign_key :users, column: :following_id, on_delete: :cascade
    end
  end
end
