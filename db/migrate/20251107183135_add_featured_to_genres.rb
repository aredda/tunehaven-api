# frozen_string_literal: true

class AddFeaturedToGenres < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_genres, :featured, :boolean, default: false
  end
end
