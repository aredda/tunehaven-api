# frozen_string_literal: true

class AddMissingLikesCountToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_albums, :likes_count, :integer, default: 0
  end
end
