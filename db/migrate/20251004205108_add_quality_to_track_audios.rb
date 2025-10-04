# frozen_string_literal: true

class AddQualityToTrackAudios < ActiveRecord::Migration[8.0]
  def change
    add_column :platform_track_audios, :quality, :string, default: :low
  end
end
