# frozen_string_literal: true

class AddAudioMetadata < ActiveRecord::Migration[8.0]
  def change
    change_table :platform_track_audios, bulk: true do |t|
      t.string :method, default: :uploaded
      t.text :unsigned_file_url, null: true
    end
  end
end
