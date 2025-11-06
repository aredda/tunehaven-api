# frozen_string_literal: true

class RemoveOldLikeRelationships < ActiveRecord::Migration[8.0]
  def change
    drop_table :user_album_saves
    drop_table :user_playlist_saves
  end
end
