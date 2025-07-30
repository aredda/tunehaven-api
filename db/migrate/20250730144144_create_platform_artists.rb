# frozen_string_literal: true

class CreatePlatformArtists < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'citext'

    create_table :platform_artists, id: :uuid do |t|
      t.citext :name, null: false
      t.text :about, null: true

      t.timestamps
    end
  end
end
