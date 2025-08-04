# frozen_string_literal: true

class AddDefaultBoolToPlaylists < ActiveRecord::Migration[8.0]
  def change
    add_column :user_playlists, :is_default, :boolean, default: false
  end
end
