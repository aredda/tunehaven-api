# frozen_string_literal: true

class RenamePlaylistSavesCount < ActiveRecord::Migration[8.0]
  def change
    rename_column :user_playlists, :saves_count, :likes_count
  end
end
