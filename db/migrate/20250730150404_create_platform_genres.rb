# frozen_string_literal: true

class CreatePlatformGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :platform_genres, id: :string do |t|
      t.string :name, null: false
      t.text :description, null: true

      t.timestamps
    end
  end
end
