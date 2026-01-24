# frozen_string_literal: true

class FixUserLikeIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :user_likes, column: %i[likable_id likable_type]

    add_index :user_likes, %i[user_id likable_id], unique: true
  end
end
