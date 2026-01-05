# frozen_string_literal: true

class AddColorToGenres < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_genres, :color, :string, null: true
  end
end
