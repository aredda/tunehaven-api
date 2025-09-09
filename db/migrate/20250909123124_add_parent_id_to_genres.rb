# frozen_string_literal: true

class AddParentIdToGenres < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_genres, :parent_id, :string, null: true

    add_foreign_key :platform_genres, :platform_genres, column: :parent_id
  end
end
