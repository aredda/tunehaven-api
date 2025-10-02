# frozen_string_literal: true

class RemoveTrackDuration < ActiveRecord::Migration[8.0]
  def change
    remove_column :platform_tracks, :duration_in_seconds, :integer
  end
end
