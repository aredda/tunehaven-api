# frozen_string_literal: true

class AddAudioCounterToTracks < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_tracks, :audios_count, :integer, default: 0
    change_column_null :platform_tracks, :duration_in_seconds, true
  end
end
