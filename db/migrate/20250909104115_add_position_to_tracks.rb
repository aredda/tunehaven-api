# frozen_string_literal: true

class AddPositionToTracks < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_tracks, :position, :integer
  end
end
