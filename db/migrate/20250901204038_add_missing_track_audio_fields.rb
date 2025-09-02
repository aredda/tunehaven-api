# frozen_string_literal: true

class AddMissingTrackAudioFields < ActiveRecord::Migration[8.0]
  def change
    change_table :platform_track_audios, bulk: true do |t|
      t.column :size, :integer
      t.column :duration, :integer
      t.column :sample_rate, :integer
      t.column :channels, :integer
      t.column :is_master, :boolean, default: false
    end
  end
end
